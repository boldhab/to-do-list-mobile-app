import '../../../../core/utils/date_helpers.dart';
import '../../domain/entities/task.dart';

List<PlannerTask> sampleTasks(DateTime now) {
  const titles = [
    'Review weekly priorities',
    'Draft project outline',
    'Read for 30 minutes',
    'Plan next week’s focus',
    'Organize reference notes',
    'Set monthly milestones',
  ];
  const offsets = [0, 0, 0, 1, 3, 8];
  return List.generate(
    titles.length,
    (index) => PlannerTask(
      id: 'sample-$index',
      title: titles[index],
      description: index == 1
          ? 'Gather ideas and decide on the first milestone.'
          : null,
      scheduledDate: shiftDay(now, offsets[index]),
      priority: [
        TaskPriority.medium,
        TaskPriority.high,
        TaskPriority.low,
      ][index % 3],
      isCompleted: index == 0,
      completedAt: index == 0 ? now : null,
      createdAt: now,
      updatedAt: now,
    ),
  );
}
