import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_helpers.dart';

final selectedDateProvider = NotifierProvider<SelectedDate, DateTime>(
  SelectedDate.new,
);

class SelectedDate extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void select(DateTime date) => state = dateOnly(date);
}
