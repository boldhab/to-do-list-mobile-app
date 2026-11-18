import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/task.dart';

class PriorityBadge extends StatelessWidget {
  const PriorityBadge(this.priority, {super.key});
  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (priority) {
      TaskPriority.low => ('Low', AppColors.success, Icons.arrow_downward),
      TaskPriority.medium => ('Medium', AppColors.warning, Icons.remove),
      TaskPriority.high => ('High', AppColors.error, Icons.arrow_upward),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
