import 'dart:math' as math;

import '../../../core/database/date_storage.dart';
import '../../../core/errors/planner_exception.dart';
import '../../../core/utils/date_helpers.dart';

enum RecurrenceFrequency { daily, weekly, monthly }

enum SeriesScope { occurrence, future, series }

class RecurrenceRule {
  const RecurrenceRule({
    required this.frequency,
    required this.start,
    this.interval = 1,
    this.weekdays = 31,
    this.monthDay = 1,
    this.end,
    this.count,
  });

  final RecurrenceFrequency frequency;
  final DateTime start;
  final int interval;
  final int weekdays;
  final int monthDay;
  final DateTime? end;
  final int? count;

  void validate() {
    if (interval < 1 ||
        interval > 365 ||
        weekdays < 1 ||
        weekdays > 127 ||
        monthDay < 1 ||
        monthDay > 31 ||
        (end?.isBefore(start) ?? false) ||
        (count != null && (count! < 1 || count! > 10000))) {
      throw PlannerException(
        'Check the repeat interval, weekdays, end date and occurrence count.',
      );
    }
  }

  Iterable<DateTime> between(DateTime from, DateTime through) sync* {
    final first = math.max(encodeDay(from), encodeDay(start));
    final last = math.min(
      encodeDay(through),
      end == null ? encodeDay(through) : encodeDay(end!),
    );
    if (last < first) return;
    final anchor = encodeDay(start);
    switch (frequency) {
      case RecurrenceFrequency.daily:
        for (
          var step = (first - anchor + interval - 1) ~/ interval;
          anchor + step * interval <= last && (count == null || step < count!);
          step++
        ) {
          yield decodeDay(anchor + step * interval);
        }
      case RecurrenceFrequency.weekly:
        final monday = encodeDay(mondayOf(start));
        final stride = 7 * interval;
        final days = [
          for (var day = 0; day < 7; day++)
            if (weekdays & (1 << day) != 0) day,
        ];
        final excluded = days.where((day) => monday + day < anchor).length;
        for (
          var week = (first - monday) ~/ stride;
          monday + week * stride <= last;
          week++
        ) {
          for (var position = 0; position < days.length; position++) {
            final day = monday + week * stride + days[position];
            final rank = week * days.length + position - excluded;
            if (count != null && rank >= count!) return;
            if (day >= first && day <= last) yield decodeDay(day);
          }
        }
      case RecurrenceFrequency.monthly:
        final lower = decodeDay(first);
        final monthOffset =
            (lower.year - start.year) * 12 + lower.month - start.month;
        // With a count, only valid dates consume an occurrence. Otherwise jump
        // directly to the first relevant month.
        var seen = 0;
        for (var step = count == null ? monthOffset ~/ interval : 0; ; step++) {
          final month = DateTime(start.year, start.month + step * interval);
          if (encodeDay(month) > last) return;
          if (monthDay > daysInMonth(month)) continue;
          final day = encodeDay(DateTime(month.year, month.month, monthDay));
          if (day < anchor) continue;
          if (count != null && seen++ >= count!) return;
          if (day >= first && day <= last) yield decodeDay(day);
        }
    }
  }

  RecurrenceRule starting(DateTime date) => RecurrenceRule(
    frequency: frequency,
    start: date,
    interval: interval,
    weekdays: weekdays,
    monthDay: monthDay,
    end: end,
    count: count,
  );
}

typedef OccurrenceId = ({String series, int day});

String occurrenceKey(String series, int day) => '$series~$day';

OccurrenceId? parseOccurrence(String id) {
  final separator = id.lastIndexOf('~');
  if (separator <= 0) return null;
  final day = int.tryParse(id.substring(separator + 1));
  if (day == null || day < -719162 || day > 2932896) return null;
  return (series: id.substring(0, separator), day: day);
}
