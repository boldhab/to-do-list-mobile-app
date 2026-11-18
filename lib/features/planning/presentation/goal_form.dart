import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helpers.dart';
import '../domain/validation.dart';

typedef GoalDraft = ({
  String title,
  String description,
  DateTime period,
  String? parentId,
  bool completed,
});

class GoalForm extends StatefulWidget {
  const GoalForm({
    super.key,
    required this.initial,
    required this.monthly,
    this.parents = const {},
    required this.onSave,
    required this.onCancel,
  });

  final GoalDraft initial;
  final bool monthly;
  final Map<String, String> parents;
  final Future<void> Function(GoalDraft) onSave;
  final VoidCallback onCancel;

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.initial.title);
  late final _description = TextEditingController(
    text: widget.initial.description,
  );
  late final _year = TextEditingController(
    text: widget.initial.period.year.toString(),
  );
  late DateTime _period = widget.initial.period;
  late String? _parent = widget.initial.parentId;
  late bool _completed = widget.initial.completed;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _chooseWeek() async {
    final day = await showDatePicker(
      context: context,
      initialDate:
          _period.year < minPlannerYear || _period.year > maxPlannerYear
          ? null
          : _period,
      firstDate: DateTime(minPlannerYear),
      lastDate: DateTime(maxPlannerYear, 12, 31),
      helpText: 'Select any day in the week',
    );
    if (mounted && day != null) setState(() => _period = mondayOf(day));
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave((
        title: _title.text,
        description: _description.text,
        period: widget.monthly
            ? DateTime(int.parse(_year.text.trim()), _period.month)
            : _period,
        parentId: _parent,
        completed: _completed,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _form,
    child: Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _title,
          maxLength: titleLimit,
          validator: titleError,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Goal title'),
        ),
        TextFormField(
          controller: _description,
          maxLength: descriptionLimit,
          minLines: 2,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
          ),
        ),
        if (widget.monthly) ...[
          DropdownButtonFormField<int>(
            initialValue: _period.month,
            decoration: const InputDecoration(labelText: 'Month'),
            isExpanded: true,
            items: [
              for (var month = 1; month <= 12; month++)
                DropdownMenuItem(
                  value: month,
                  child: Text(DateFormat.MMMM().format(DateTime(2000, month))),
                ),
            ],
            onChanged: (month) {
              if (month != null) {
                setState(() => _period = DateTime(_period.year, month));
              }
            },
          ),
          TextFormField(
            controller: _year,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Year'),
            validator: (value) {
              final year = int.tryParse(value?.trim() ?? '');
              return year == null ||
                      year < minPlannerYear ||
                      year > maxPlannerYear
                  ? 'Enter a year from $minPlannerYear to $maxPlannerYear.'
                  : null;
            },
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _chooseWeek,
            icon: const Icon(Icons.date_range_outlined),
            label: Text(
              '${DateFormat.yMMMd().format(_period)} – ${DateFormat.yMMMd().format(sundayOf(_period))}',
              textAlign: TextAlign.center,
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _parent ?? '',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Monthly goal (optional)',
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('Independent')),
              for (final entry in widget.parents.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value, overflow: TextOverflow.ellipsis),
                ),
              if (_parent != null && !widget.parents.containsKey(_parent))
                DropdownMenuItem(
                  value: _parent,
                  child: const Text('Unavailable goal'),
                ),
            ],
            onChanged: (id) => setState(() => _parent = id == '' ? null : id),
          ),
        ],
        SwitchListTile(
          title: const Text('Goal completed'),
          value: _completed,
          onChanged: (value) => setState(() => _completed = value),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: _saving ? null : _save,
              child: const Text('Save Goal'),
            ),
            OutlinedButton(
              onPressed: _saving ? null : widget.onCancel,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    ),
  );
}
