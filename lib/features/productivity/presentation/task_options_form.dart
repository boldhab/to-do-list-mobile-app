import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/date_helpers.dart';
import '../../recurrence/domain/recurrence_rule.dart';
import '../../reminders/domain/reminder_rule.dart';
import '../../reminders/presentation/reminder_provider.dart';
import '../data/preferences.dart';
import '../data/productivity_store.dart';

const emptyTaskOptions = (
  repeat: null,
  reminder: null,
  scope: SeriesScope.series,
);

String permissionLabel(PermissionStatus status) => switch (status) {
  PermissionStatus.checking => 'Checking notification permission',
  PermissionStatus.allowed => 'Notifications allowed',
  PermissionStatus.denied => 'Notifications are off on this device',
  PermissionStatus.unavailable => 'Notifications unavailable',
};

class TaskOptionsForm extends StatefulWidget {
  const TaskOptionsForm({
    super.key,
    required this.initial,
    required this.date,
    this.dueAt,
    required this.recurringOccurrence,
    required this.defaultOffset,
    required this.permission,
    required this.onChange,
    required this.requestPermission,
  });

  final TaskOptions initial;
  final DateTime date;
  final DateTime? dueAt;
  final bool recurringOccurrence;
  final int defaultOffset;
  final PermissionStatus permission;
  final ValueChanged<TaskOptions> onChange;
  final VoidCallback requestPermission;

  @override
  State<TaskOptionsForm> createState() => _TaskOptionsFormState();
}

class _TaskOptionsFormState extends State<TaskOptionsForm> {
  late bool _repeat = widget.initial.repeat != null;
  late RecurrenceFrequency _frequency =
      widget.initial.repeat?.frequency ?? RecurrenceFrequency.daily;
  late int _interval = widget.initial.repeat?.interval ?? 1;
  late int _days =
      widget.initial.repeat?.weekdays ?? (1 << (widget.date.weekday - 1));
  late int _monthDay = widget.initial.repeat?.monthDay ?? widget.date.day;
  DateTime? _start;
  late DateTime? _end = widget.initial.repeat?.end;
  late int? _count = widget.initial.repeat?.count;
  late SeriesScope _scope = widget.initial.scope;
  late bool _enabled = widget.initial.reminder != null;
  late int _offset = widget.initial.reminder?.customAt != null
      ? -1
      : widget.initial.reminder?.minutesBefore ?? widget.defaultOffset;
  late DateTime? _custom = widget.initial.reminder?.customAt;

  DateTime get _effectiveStart =>
      _start ??
      (_scope == SeriesScope.future
          ? widget.date
          : widget.initial.repeat?.start ?? widget.date);

  ReminderDraft? get _draft => !_enabled
      ? null
      : _offset == -1
      ? ReminderDraft(customAt: _custom)
      : ReminderDraft(minutesBefore: _offset);

  TaskOptions get _options => (
    repeat: _repeat
        ? RecurrenceRule(
            frequency: _frequency,
            start: _effectiveStart,
            end: _end,
            count: _count,
            interval: _interval,
            weekdays: _days,
            monthDay: _monthDay,
          )
        : null,
    reminder: _draft,
    scope: _scope,
  );

  @override
  void didUpdateWidget(covariant TaskOptionsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) widget.onChange(_options);
  }

  void _change(VoidCallback mutation) {
    setState(mutation);
    widget.onChange(_options);
  }

  Future<DateTime?> _day(DateTime initial) => showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(1),
    lastDate: DateTime(9999, 12, 31),
  );

  Future<void> _pickReminder() async {
    final initial =
        _custom ?? widget.dueAt ?? DateTime.now().add(const Duration(hours: 1));
    final day = await _day(initial);
    if (!mounted || day == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!mounted || time == null) return;
    _change(
      () => _custom = DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final when = _draft?.fireAt(widget.dueAt)?.toLocal();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.recurringOccurrence)
          DropdownButtonFormField<SeriesScope>(
            initialValue: _scope,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Apply changes to'),
            items: const [
              DropdownMenuItem(
                value: SeriesScope.occurrence,
                child: Text('This occurrence'),
              ),
              DropdownMenuItem(
                value: SeriesScope.future,
                child: Text('This and future occurrences'),
              ),
              DropdownMenuItem(
                value: SeriesScope.series,
                child: Text('Entire series'),
              ),
            ],
            onChanged: (scope) {
              if (scope != null) {
                _change(() {
                  _scope = scope;
                  _start = null;
                });
              }
            },
          )
        else
          SwitchListTile(
            title: const Text('Repeat task'),
            value: _repeat,
            subtitle: const Text(
              'Repeating tasks are independent of weekly goals.',
            ),
            onChanged: (value) => _change(() => _repeat = value),
          ),
        if (_repeat && _scope != SeriesScope.occurrence) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<RecurrenceFrequency>(
            initialValue: _frequency,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Repeat frequency'),
            items: [
              for (final frequency in RecurrenceFrequency.values)
                DropdownMenuItem(value: frequency, child: Text(frequency.name)),
            ],
            onChanged: (frequency) {
              if (frequency != null) _change(() => _frequency = frequency);
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: '$_interval',
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Repeat interval'),
            onChanged: (value) =>
                _change(() => _interval = int.tryParse(value) ?? 0),
          ),
          if (_frequency == RecurrenceFrequency.weekly)
            Wrap(
              spacing: 6,
              children: [
                for (var day = 0; day < 7; day++)
                  FilterChip(
                    label: Text(
                      DateFormat.E().format(
                        shiftDay(DateTime(2026, 1, 5), day),
                      ),
                    ),
                    selected: (_days & (1 << day)) != 0,
                    onSelected: (_) => _change(() => _days ^= 1 << day),
                  ),
              ],
            ),
          if (_frequency == RecurrenceFrequency.monthly)
            DropdownButtonFormField<int>(
              initialValue: _monthDay,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Day of month',
                helperText: 'Shorter months skip missing dates.',
              ),
              items: [
                for (var i = 1; i <= 31; i++)
                  DropdownMenuItem(value: i, child: Text('$i')),
              ],
              onChanged: (day) {
                if (day != null) _change(() => _monthDay = day);
              },
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _scope == SeriesScope.future
                    ? null
                    : () async {
                        final value = await _day(_effectiveStart);
                        if (mounted && value != null) {
                          _change(() => _start = value);
                        }
                      },
                child: Text(
                  'Starts ${plannerDate(_effectiveStart, defaultPreferences)}',
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  final value = await _day(_end ?? _effectiveStart);
                  if (mounted && value != null) _change(() => _end = value);
                },
                child: Text(
                  _end == null
                      ? 'Set repeat end date'
                      : 'Ends ${DateFormat.yMMMd().format(_end!)}',
                ),
              ),
              if (_end != null)
                TextButton(
                  onPressed: () => _change(() => _end = null),
                  child: const Text('Clear end date'),
                ),
            ],
          ),
          TextFormField(
            initialValue: _count?.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Maximum occurrences (optional)',
            ),
            onChanged: (value) => _change(
              () => _count = value.trim().isEmpty
                  ? null
                  : int.tryParse(value) ?? 0,
            ),
          ),
        ],
        SwitchListTile(
          title: const Text('Task reminder'),
          value: _enabled,
          subtitle: Text(permissionLabel(widget.permission)),
          onChanged: (value) => _change(() => _enabled = value),
        ),
        if (_enabled) ...[
          if (widget.permission == PermissionStatus.denied)
            TextButton(
              onPressed: widget.requestPermission,
              child: const Text('Request notification permission'),
            ),
          DropdownButtonFormField<int>(
            initialValue: _offset,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Reminder timing'),
            items: [
              for (final offset in reminderOffsets)
                DropdownMenuItem(
                  value: offset,
                  child: Text(reminderOffsetLabel(offset)),
                ),
              const DropdownMenuItem(
                value: -1,
                child: Text('Custom date and time'),
              ),
            ],
            onChanged: (offset) {
              if (offset != null) _change(() => _offset = offset);
            },
          ),
          if (_offset == -1)
            OutlinedButton(
              onPressed: _pickReminder,
              child: const Text('Choose reminder date and time'),
            ),
          if (when != null)
            Text('Reminder at ${DateFormat.yMMMd().add_jm().format(when)}')
          else
            Text(
              _offset == -1
                  ? 'Choose a reminder date and time.'
                  : 'Set a deadline to use this reminder.',
            ),
        ],
      ],
    );
  }
}
