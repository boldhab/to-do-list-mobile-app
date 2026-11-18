import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../features/tasks/presentation/providers/task_provider.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.featured = false,
  });
  final String title;
  final TaskProgress progress;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: featured ? colors.primaryContainer : colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: featured ? colors.onPrimaryContainer : colors.onSurface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: featured
                      ? colors.onPrimaryContainer
                      : colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${progress.percentage}%',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: featured
                      ? colors.onPrimaryContainer
                      : colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(
                value: progress.ratio,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
                semanticsLabel: title,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.xs,
                children: [
                  Text('${progress.total} total'),
                  Text('${progress.completed} completed'),
                  Text('${progress.pending} pending'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
