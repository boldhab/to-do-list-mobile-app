const _millisecondsPerDay = Duration.millisecondsPerDay;

// UTC is used as a timezone-free coordinate for calendar components.
int encodeDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
    _millisecondsPerDay;

DateTime decodeDay(int value) {
  final day = DateTime.fromMillisecondsSinceEpoch(
    value * _millisecondsPerDay,
    isUtc: true,
  );
  return DateTime(day.year, day.month, day.day);
}
