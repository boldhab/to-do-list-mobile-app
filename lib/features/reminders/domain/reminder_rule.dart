class ReminderDraft {
  const ReminderDraft({this.minutesBefore, this.customAt});
  final int? minutesBefore;
  final DateTime? customAt;

  DateTime? fireAt(DateTime? deadline) =>
      customAt?.toUtc() ??
      (minutesBefore == null
          ? null
          : deadline?.toUtc().subtract(Duration(minutes: minutesBefore!)));
}

const reminderOffsets = [0, 5, 10, 15, 30, 60, 1440];

String reminderOffsetLabel(int minutes) => switch (minutes) {
  0 => 'At deadline',
  60 => '1 hour before',
  1440 => '1 day before',
  _ => '$minutes minutes before',
};
