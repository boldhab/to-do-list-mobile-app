import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/date_storage.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/utils/progress_calculator.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/progress_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../../planning/presentation/goal_cards.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../../../productivity/data/preferences.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';
import '../../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../../domain/productivity_metrics.dart';

enum _Period { today, week, month, custom }

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  _Period _period = _Period.week;
  DateRange? _custom;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = dateOnly(now);
    final startOfMonth = shiftMonth(today, 0);
    final range = switch (_period) {
      _Period.today => (start: today, end: today),
      _Period.week => (start: mondayOf(today), end: sundayOf(today)),
      _Period.month => (
        start: startOfMonth,
        end: shiftDay(shiftMonth(today, 1), -1),
      ),
      _Period.custom => _custom!,
    };
    final preferences = ref.watch(preferencesProvider);
    final query = ref.watch(tasksInPeriodProvider(range));
    final tasks = query.asData?.value;
    final previousMonth = shiftMonth(today, -1);
    final previous = _period == _Period.month
        ? ref.watch(
            tasksInPeriodProvider((
              start: previousMonth,
              end: shiftDay(startOfMonth, -1),
            )),
          )
        : null;
    final streak = ref.watch(
      tasksInPeriodProvider((start: shiftDay(today, -89), end: today)),
    );
    final monthly = ref.watch(monthlyGoalsProvider).where((goal) {
      final month = DateTime(goal.year, goal.month);
      return !month.isAfter(range.end) &&
          !shiftDay(shiftMonth(month, 1), -1).isBefore(range.start);
    }).toList();
    final weekly = ref
        .watch(weeklyGoalsProvider)
        .where(
          (goal) =>
              !goal.weekStart.isAfter(range.end) &&
              !goal.weekEnd.isBefore(range.start),
        )
        .toList();
    final buckets = tasks == null
        ? const <PerformanceBucket>[]
        : performanceBuckets(
            tasks,
            range.start,
            range.end,
            stride:
                _period == _Period.month ||
                    encodeDay(range.end) - encodeDay(range.start) > 31
                ? 7
                : 1,
          );
    return PlannerPage(
      title: 'Productivity analytics',
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (period, label) in [
              (_Period.today, 'Today'),
              (_Period.week, 'This week'),
              (_Period.month, 'This month'),
              (_Period.custom, 'Custom range'),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _period == period,
                onSelected: (_) async {
                  if (period == _Period.custom) {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(1),
                      lastDate: DateTime(9999, 12, 31),
                      initialDateRange: _custom == null
                          ? null
                          : DateTimeRange(
                              start: _custom!.start,
                              end: _custom!.end,
                            ),
                    );
                    if (!context.mounted || picked == null) return;
                    if (encodeDay(picked.end) - encodeDay(picked.start) > 366) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Choose a range of up to 367 days.'),
                        ),
                      );
                      return;
                    }
                    _custom = (start: picked.start, end: picked.end);
                  }
                  if (mounted) setState(() => _period = period);
                },
              ),
          ],
        ),
        Text(
          '${plannerDate(range.start, preferences)} – ${plannerDate(range.end, preferences)}',
        ),
        if (tasks == null)
          PlannerQueryStatus(query)
        else ...[
          ProgressCard(
            title: 'Scheduled task completion',
            progress: TaskProgress(tasks),
            featured: true,
          ),
          Text(
            '${overdueCount(tasks, now)} overdue · ${monthly.where((goal) => goal.isCompleted).length} completed monthly goals · ${weekly.where((goal) => goal.isCompleted).length} completed weekly goals',
          ),
          if (tasks.isEmpty)
            const EmptyState('No tasks were scheduled for this period.')
          else
            _PerformanceChart(buckets: buckets),
        ],
        if (previous != null)
          if (previous.asData case final data?)
            ProgressCard(
              title:
                  'Previous month · ${DateFormat.yMMMM().format(previousMonth)}',
              progress: TaskProgress(data.value),
            )
          else
            PlannerQueryStatus(previous),
        if (streak.asData case final data?) ...[
          const SectionHeader('Completion streak'),
          Text('${completionStreak(data.value, today)} days'),
          const Text(
            'Counts up to 90 consecutive days with at least one scheduled task and every task complete. Late completions count on the scheduled day, and recurring tasks count per occurrence. An unfinished today does not break the streak until the day ends.',
          ),
        ],
        const SectionHeader('Monthly goal progress'),
        if (monthly.isEmpty) const Text('No monthly goals in this period.'),
        for (final goal in monthly) MonthlyGoalCard(goal),
        const SectionHeader('Weekly objective progress'),
        if (weekly.isEmpty) const Text('No weekly objectives in this period.'),
        for (final goal in weekly) WeeklyGoalCard(goal),
      ],
    );
  }
}

class _PerformanceChart extends StatelessWidget {
  const _PerformanceChart({required this.buckets});
  final List<PerformanceBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maximum = buckets.fold<int>(
      1,
      (max, item) => math.max(max, item.planned),
    );
    final interval = math.max(1, (maximum / 4).ceil()).toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            const SectionHeader('Planned and completed tasks'),
            Text(
              'Left bar planned · Right bar completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 224,
                  width: math.max(
                    constraints.maxWidth,
                    buckets.length * 66 + 36,
                  ),
                  child: BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: (maximum / interval).ceil() * interval,
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: interval,
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: interval,
                            reservedSize: 36,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (value != index ||
                                  index < 0 ||
                                  index >= buckets.length) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                DateFormat.MMMd().format(buckets[index].day),
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        for (var i = 0; i < buckets.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: buckets[i].planned.toDouble(),
                                color: colors.secondary,
                                width: 12,
                              ),
                              BarChartRodData(
                                toY: buckets[i].completed.toDouble(),
                                color: colors.primary,
                                width: 12,
                              ),
                            ],
                          ),
                      ],
                    ),
                    duration: Duration.zero,
                  ),
                ),
              ),
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('View chart values'),
              children: [
                for (final bucket in buckets)
                  ListTile(
                    title: Text(DateFormat.yMMMd().format(bucket.day)),
                    subtitle: Text(
                      '${bucket.completed} completed of ${bucket.planned} planned',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
