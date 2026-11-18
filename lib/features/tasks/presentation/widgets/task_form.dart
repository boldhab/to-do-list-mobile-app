import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../planning/domain/validation.dart';
import '../../../weekly_planner/domain/entities/weekly_goal.dart';
import '../../domain/entities/task.dart';
import '../../../productivity/data/productivity_store.dart';
import '../../../productivity/presentation/task_options_form.dart';
import '../../../reminders/presentation/reminder_provider.dart';
import '../../../recurrence/domain/recurrence_rule.dart';

typedef TaskSubmit = Future<void> Function(
  String title,
  String description,
  DateTime date,
  TaskPriority priority,
  bool completed,
  DateTime? dueAt,
  String? weeklyGoalId,
  TaskOptions options,
);

class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    this.task,
    this.weeklyGoalId,
    required this.goals,
    required this.initialDate,
    required this.onSave,
    this.options = emptyTaskOptions,
    this.pickDateOnOpen = false,
    this.enableAdvanced = false,
    this.defaultOffset = 15,
    this.permission = PermissionStatus.unavailable,
    this.requestPermission,
  });

  final PlannerTask? task;
  final String? weeklyGoalId;
  final List<WeeklyGoal> goals;
  final DateTime initialDate;
  final TaskSubmit onSave;
  final TaskOptions options;
  final bool pickDateOnOpen;
  final bool enableAdvanced;
  final int defaultOffset;
  final PermissionStatus permission;
  final VoidCallback? requestPermission;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _key = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.task?.title);
  late final _description = TextEditingController(
    text: widget.task?.description,
  );
  late DateTime _date = widget.initialDate;
  late DateTime? _dueAt = widget.task?.dueAt;
  late String? _goalId = widget.task?.weeklyGoalId ?? widget.weeklyGoalId;
  late TaskPriority _priority = widget.task?.priority ?? TaskPriority.medium;
  late bool _completed = widget.task?.isCompleted ?? false;

  late TaskOptions _options = widget.options;
  bool _saving = false;

  Future<void> _save() async {
    if (_saving || !_key.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        _title.text,
        _description.text,
        _date,
        _priority,
        _completed,
        _dueAt,
        _goalId,
        _options,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.pickDateOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _pickDate();
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate({bool deadline = false}) async {
    final initial = deadline ? _dueAt ?? _date : _date;
    final min = DateTime(minPlannerYear);
    final max = DateTime(maxPlannerYear, 12, 31);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(min) || dateOnly(initial).isAfter(max)
          ? null
          : initial,
      firstDate: min,
      lastDate: max,
      helpText: deadline ? 'Choose a deadline' : 'Choose a scheduled date',
    );
    if (!mounted || picked == null) return;
    if (!deadline) {
      setState(() => _date = picked);
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: _dueAt == null
          ? const TimeOfDay(hour: 17, minute: 0)
          : TimeOfDay.fromDateTime(_dueAt!),
      helpText: 'Choose a deadline time',
    );
    if (mounted && time != null) {
      setState(
        () => _dueAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  String? _validateGoal(String? id) {
    if (id == null || id.isEmpty) return null;
    final goal = widget.goals.where((goal) => goal.id == id).firstOrNull;
    if (goal == null) return 'This weekly goal is unavailable.';
    if (!dateInRange(_date, goal.weekStart, goal.weekEnd)) {
      return 'Choose a scheduled date in this goal’s week, or unlink it.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _title,
          decoration: const InputDecoration(labelText: 'Task title'),
          maxLength: titleLimit,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          validator: (value) {
            final title = (value ?? '').trim();
            if (title.isEmpty) return 'Enter a task title.';
            if (title.length > titleLimit) {
              return 'Use at most $titleLimit characters.';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: _description,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
            alignLabelWithHint: true,
          ),
          maxLength: descriptionLimit,
          minLines: 3,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(
            'Scheduled date · ${DateFormat.yMMMd().format(_date)}',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickDate(deadline: true),
              icon: const Icon(Icons.schedule),
              label: Text(
                _dueAt == null
                    ? 'Set deadline'
                    : 'Deadline · ${DateFormat.yMMMd().add_jm().format(_dueAt!)}',
              ),
            ),
            if (_dueAt != null)
              TextButton(
                onPressed: () => setState(() => _dueAt = null),
                child: const Text('Clear deadline'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<String>(
          initialValue: _goalId ?? '',
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Weekly goal (optional)',
          ),
          items: [
            const DropdownMenuItem(value: '', child: Text('Independent')),
            for (final goal in widget.goals)
              DropdownMenuItem(
                value: goal.id,
                child: Text(
                  '${goal.title} · ${DateFormat.yMMMd().format(goal.weekStart)}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (_goalId != null &&
                !widget.goals.any((goal) => goal.id == _goalId))
              DropdownMenuItem(
                value: _goalId,
                child: const Text('Unavailable goal'),
              ),
          ],
          validator: _validateGoal,
          onChanged: (id) => setState(() => _goalId = id == '' ? null : id),
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<TaskPriority>(
          initialValue: _priority,
          decoration: const InputDecoration(labelText: 'Priority'),
          items: const [
            DropdownMenuItem(value: TaskPriority.low, child: Text('Low')),
            DropdownMenuItem(value: TaskPriority.medium, child: Text('Medium')),
            DropdownMenuItem(value: TaskPriority.high, child: Text('High')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _priority = value);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        if (widget.task != null)
          SwitchListTile(
            title: const Text('Completed'),
            value: _completed,
            onChanged: (value) => setState(() => _completed = value),
          ),
        const SizedBox(height: AppSpacing.lg),
        if (widget.enableAdvanced)
          TaskOptionsForm(
            initial: widget.options,
            date: _date,
            dueAt: _dueAt,
            recurringOccurrence:
                widget.task != null && parseOccurrence(widget.task!.id) != null,
            defaultOffset: widget.defaultOffset,
            permission: widget.permission,
            requestPermission: widget.requestPermission ?? () {},
            onChange: (options) => _options = options,
          ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Save Task'),
        ),
      ],
    ),
  );
}
