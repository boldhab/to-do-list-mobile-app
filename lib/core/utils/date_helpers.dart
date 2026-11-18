typedef DateRange = ({DateTime start, DateTime end});

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
DateTime shiftDay(DateTime value, int days) =>
    DateTime(value.year, value.month, value.day + days);
DateTime shiftMonth(DateTime value, int months) =>
    DateTime(value.year, value.month + months);
DateTime mondayOf(DateTime value) => shiftDay(value, 1 - value.weekday);
DateTime sundayOf(DateTime value) => shiftDay(mondayOf(value), 6);
int daysInMonth(DateTime value) => DateTime(value.year, value.month + 1, 0).day;
bool sameDay(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);

bool dateInRange(DateTime date, DateTime start, DateTime end) {
  final day = dateOnly(date);
  return !day.isBefore(dateOnly(start)) && !day.isAfter(dateOnly(end));
}

DateTime dateForWeek(DateTime preferred, DateTime start) =>
    dateInRange(preferred, start, shiftDay(start, 6))
    ? dateOnly(preferred)
    : start;
