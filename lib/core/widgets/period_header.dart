import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

class PeriodHeader extends StatelessWidget {
  const PeriodHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.unit,
    required this.onPrevious,
    required this.onNext,
  });
  final String title;
  final String? subtitle;
  final String unit;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton.outlined(
        onPressed: onPrevious,
        tooltip: 'Previous $unit',
        icon: const Icon(Icons.chevron_left),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subtitle != null)
                Text(subtitle!, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      IconButton.outlined(
        onPressed: onNext,
        tooltip: 'Next $unit',
        icon: const Icon(Icons.chevron_right),
      ),
    ],
  );
}
