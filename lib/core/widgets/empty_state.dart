import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(this.message, {super.key, this.onAdd});
  final String message;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(message, textAlign: TextAlign.center),
          if (onAdd != null)
            TextButton(onPressed: onAdd, child: const Text('Add Task')),
        ],
      ),
    ),
  );
}
