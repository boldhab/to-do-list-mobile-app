import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../core/database/date_storage.dart';
import '../../planning/presentation/planner_provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../planning/presentation/planner_query_status.dart';
import '../../productivity/data/preferences.dart';
import '../../productivity/data/productivity_store.dart';
import '../../tasks/domain/entities/task.dart';
import '../../tasks/presentation/providers/task_query_provider.dart';
import '../../tasks/presentation/widgets/task_card.dart';
import '../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../domain/task_search.dart';

final _globalTasks = StreamProvider.autoDispose
    .family<List<PlannerTask>, DateTime>((ref, day) {
      final store = ref.watch(productivityStoreProvider);
      return store.watchChanges(
        store.taskTables,
        () => store.forRange(
          DateTime(1),
          null,
          seriesFrom: shiftDay(day, -30),
          seriesThrough: shiftDay(day, 90),
        ),
      );
    });

DateRange? _searchRange(SearchFilters filters, DateTime today) =>
    switch (filters.period) {
      SearchPeriod.all => null,
      SearchPeriod.today => (start: today, end: today),
      SearchPeriod.week => (start: mondayOf(today), end: sundayOf(today)),
      SearchPeriod.month => (
        start: shiftMonth(today, 0),
        end: shiftDay(shiftMonth(today, 1), -1),
      ),
      SearchPeriod.custom => filters.custom,
    };

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.overdue = false});
  final bool overdue;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late SearchFilters _filters = widget.overdue
      ? (
          status: SearchStatus.overdue,
          priority: null,
          link: TaskLink.all,
          recurring: false,
          sort: SearchSort.deadline,
          period: SearchPeriod.all,
          custom: null,
        )
      : defaultSearchFilters;
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = dateOnly(now);
    final range = _searchRange(_filters, today);
    final query = range == null
        ? ref.watch(usesPlannerFixtureProvider)
              ? AsyncData(ref.watch(plannerProvider).tasks)
              : ref.watch(_globalTasks(today))
        : ref.watch(tasksInPeriodProvider(range));
    final parents = {
      for (final goal in ref.watch(monthlyGoalsProvider)) goal.id: goal.title,
    };
    final labels = {
      for (final goal in ref.watch(weeklyGoalsProvider))
        goal.id: '${goal.title} ${parents[goal.monthlyGoalId] ?? ''}',
    };
    final matches = filterAndSortTasks(
      query.asData?.value ?? const [],
      _query,
      _filters,
      now,
      labels,
    );
    final preferences = ref.watch(preferencesProvider);
    return PlannerPage(
      title: 'Search tasks',
      taskItemCount: matches.length,
      taskItemBuilder: (context, index) =>
          TaskListItem(matches[index], key: ValueKey(matches[index].id)),
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            labelText: 'Title, description or goal',
          ),
          onChanged: (text) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 300), () {
              if (mounted) {
                setState(() {
                  _query = normalizedSearch(text);
                });
              }
            });
          },
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.tune),
              label: const Text('Filters and sort'),
              onPressed: () async {
                final value = await showModalBottomSheet<SearchFilters>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => _FilterSheet(initial: _filters),
                );
                if (mounted && value != null) {
                  setState(() {
                    _filters = value;
                  });
                }
              },
            ),
            Chip(label: Text(_label(_filters.status))),
            Chip(label: Text(_label(_filters.period))),
            if (_filters.priority != null)
              Chip(label: Text(_label(_filters.priority!))),
            if (_filters.link != TaskLink.all)
              Chip(label: Text(_label(_filters.link))),
            if (_filters.recurring) const Chip(label: Text('Recurring')),
            Chip(label: Text(_label(_filters.sort))),
          ],
        ),
        if (range == null)
          const Text(
            'Choose a date range to see recurring tasks outside the nearby 120-day window.',
          )
        else
          Text(
            '${plannerDate(range.start, preferences)} – ${plannerDate(range.end, preferences)}',
          ),
        if (query.asData == null)
          PlannerQueryStatus(query)
        else if (matches.isEmpty)
          const EmptyState(
            'No tasks match these filters. Try clearing a filter or changing the search text.',
          )
        else
          Text('${matches.length} matches'),
      ],
    );
  }
}

String _label(Enum value) => switch (value) {
  SearchPeriod.all => 'All dates',
  SearchPeriod.week => 'This week',
  SearchPeriod.month => 'This month',
  SearchPeriod.custom => 'Custom range',
  SearchStatus.all => 'All statuses',
  TaskLink.all => 'Any association',
  SearchSort.dateAscending => 'Scheduled date ↑',
  SearchSort.dateDescending => 'Scheduled date ↓',
  SearchSort.created => 'Recently created',
  SearchSort.updated => 'Recently updated',
  SearchSort.completion => 'Completion status',
  _ => '${value.name[0].toUpperCase()}${value.name.substring(1)}',
};

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});
  final SearchFilters initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late SearchStatus _status = widget.initial.status;
  late SearchPeriod _period = widget.initial.period;
  late SearchSort _sort = widget.initial.sort;
  late TaskLink _link = widget.initial.link;
  late TaskPriority? _priority = widget.initial.priority;
  late bool _recurring = widget.initial.recurring;
  late DateRange? _range = widget.initial.custom;

  Widget _select<T extends Enum>(
    String label,
    T current,
    List<T> values,
    ValueChanged<T> change,
  ) => DropdownButtonFormField<T>(
    key: ValueKey((label, current)),
    initialValue: current,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final value in values)
        DropdownMenuItem(value: value, child: Text(_label(value))),
    ],
    onChanged: (value) {
      if (value != null) setState(() => change(value));
    },
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            'Filters and sort',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _select(
            'Status',
            _status,
            SearchStatus.values,
            (value) => _status = value,
          ),
          _select(
            'Scheduled period',
            _period,
            SearchPeriod.values,
            (value) => _period = value,
          ),
          if (_period == SearchPeriod.custom)
            OutlinedButton(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1),
                  lastDate: DateTime(9999, 12, 31),
                  initialDateRange: _range == null
                      ? null
                      : DateTimeRange(start: _range!.start, end: _range!.end),
                );
                if (!context.mounted || range == null) return;
                if (encodeDay(range.end) - encodeDay(range.start) > 366) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Choose a range of up to 367 days.'),
                    ),
                  );
                  return;
                }
                setState(() => _range = (start: range.start, end: range.end));
              },
              child: Text(
                _range == null
                    ? 'Choose date range'
                    : '${_range!.start.toString().split(' ').first} – ${_range!.end.toString().split(' ').first}',
              ),
            ),
          _select(
            'Association',
            _link,
            TaskLink.values,
            (value) => _link = value,
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(_priority),
            initialValue: _priority?.name ?? '',
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: [
              const DropdownMenuItem(value: '', child: Text('Any priority')),
              for (final value in TaskPriority.values)
                DropdownMenuItem(value: value.name, child: Text(_label(value))),
            ],
            onChanged: (value) => setState(
              () => _priority = value == null || value.isEmpty
                  ? null
                  : TaskPriority.values.byName(value),
            ),
          ),
          SwitchListTile(
            title: const Text('Recurring tasks only'),
            value: _recurring,
            onChanged: _link == TaskLink.linked
                ? null
                : (value) => setState(() => _recurring = value),
          ),
          if (_link == TaskLink.linked && _recurring)
            const Text(
              'Repeating tasks are independent. Choose a different association or reset filters.',
            ),
          _select(
            'Sort by',
            _sort,
            SearchSort.values,
            (value) => _sort = value,
          ),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed:
                    (_period == SearchPeriod.custom && _range == null) ||
                        (_link == TaskLink.linked && _recurring)
                    ? null
                    : () => Navigator.pop(context, (
                        status: _status,
                        priority: _priority,
                        link: _link,
                        recurring: _recurring,
                        sort: _sort,
                        period: _period,
                        custom: _range,
                      )),
                child: const Text('Apply'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, defaultSearchFilters),
                child: const Text('Reset filters'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
