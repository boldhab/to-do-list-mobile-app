import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/database/date_storage.dart';
import '../../../tasks/domain/entities/task.dart';

DateTime displayWeekOf(DateTime date, bool sundayFirst) =>
    sundayFirst ? shiftDay(date, -(date.weekday % 7)) : mondayOf(date);

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.selected,
    required this.today,
    required this.tasks,
    required this.onSelect,
    this.weekView = false,
    this.sundayFirst = false,
  });

  final DateTime month;
  final DateTime selected;
  final DateTime today;
  final List<PlannerTask> tasks;
  final ValueChanged<DateTime> onSelect;
  final bool weekView;
  final bool sundayFirst;

  @override
  Widget build(BuildContext context) {
    final first = displayWeekOf(weekView ? selected : month, sundayFirst);
    final offset = weekView ? 0 : encodeDay(month) - encodeDay(first);
    final last = weekView ? 7 : daysInMonth(month) + math.max(0, offset);
    final slots = weekView ? 7 : ((last + 6) ~/ 7) * 7;
    final byDate = <DateTime, List<PlannerTask>>{};
    for (final task in tasks) {
      (byDate[dateOnly(task.scheduledDate)] ??= []).add(task);
    }
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = math
                .max(constraints.maxWidth / 7, math.max(48, 32 * scale + 12))
                .toDouble();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      for (var index = 0; index < 7; index++)
                        SizedBox(
                          width: width,
                          child: Text(
                            DateFormat.EEEEE().format(shiftDay(first, index)),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                    ],
                  ),
                  for (var row = 0; row < slots; row += 7)
                    Row(
                      children: [
                        for (var column = 0; column < 7; column++)
                          SizedBox(
                            width: width,
                            height: math.max(58, 43 * scale).toDouble(),
                            child: _day(
                              context,
                              shiftDay(first, row + column),
                              byDate,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _day(
    BuildContext context,
    DateTime date,
    Map<DateTime, List<PlannerTask>> byDate,
  ) {
    if (!weekView && date.month != month.month) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    final items = byDate[date] ?? const [];
    final completed = items.where((task) => task.isCompleted).length;
    final overdue = items
        .where(
          (task) => !task.isCompleted && task.dueAt?.isBefore(today) == true,
        )
        .length;
    final isToday = sameDay(today, date);
    final isSelected = sameDay(selected, date);
    return Semantics(
      button: true,
      selected: isSelected,
      label:
          '${DateFormat.yMMMMEEEEd().format(date)}${isToday ? ', today' : ''}, ${items.length} tasks, $completed completed, $overdue overdue',
      child: InkWell(
        onTap: () => onSelect(date),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryContainer : null,
            border: isToday
                ? Border.all(color: colors.primary, width: 2)
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w800
                        : FontWeight.w500,
                  ),
                ),
                if (items.isNotEmpty)
                  Text(
                    '${items.length}${overdue > 0
                        ? ' !'
                        : completed > 0
                        ? ' ✓'
                        : ' •'}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: overdue > 0 ? colors.error : colors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
