import 'package:flutter/material.dart';

/// A reusable progress card widget showing progress with a bar.
///
/// Displays a progress bar with optional label, percentage, and description.
///
/// Example:
/// ```dart
/// ReusableProgressCard(
///   title: 'Profile Completion',
///   progress: 0.75,
///   showPercentage: true,
///   description: '3 out of 4 steps completed',
/// )
/// ```
class ReusableProgressCard extends StatelessWidget {
  /// Title text
  final String title;

  /// Progress value (0.0 to 1.0)
  final double progress;

  /// Whether to show percentage text
  final bool showPercentage;

  /// Optional description text
  final String? description;

  /// Progress bar color
  final Color? progressColor;

  /// Background color for progress bar
  final Color? backgroundColor;

  /// Optional icon
  final IconData? icon;

  const ReusableProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.showPercentage = true,
    this.description,
    this.progressColor,
    this.backgroundColor,
    this.icon,
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress must be between 0.0 and 1.0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = progressColor ?? theme.colorScheme.primary;
    final bgColor = backgroundColor ?? theme.colorScheme.surfaceVariant;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: barColor),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showPercentage)
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: barColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
