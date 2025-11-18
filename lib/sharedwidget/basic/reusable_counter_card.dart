import 'package:flutter/material.dart';

/// A reusable counter card widget for displaying metrics and statistics.
///
/// Shows a number with an optional label, icon, and trend indicator.
///
/// Example:
/// ```dart
/// ReusableCounterCard(
///   count: 1234,
///   label: 'Total Sales',
///   icon: Icons.shopping_cart,
///   trend: '+12%',
///   trendPositive: true,
/// )
/// ```
class ReusableCounterCard extends StatelessWidget {
  /// The counter value
  final int count;

  /// Label text below the count
  final String label;

  /// Icon to display
  final IconData? icon;

  /// Trend text (e.g., "+12%")
  final String? trend;

  /// Whether trend is positive (green) or negative (red)
  final bool trendPositive;

  /// Background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  const ReusableCounterCard({
    super.key,
    required this.count,
    required this.label,
    this.icon,
    this.trend,
    this.trendPositive = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final fgColor = textColor ?? theme.colorScheme.onSurface;

    return Card(
      color: bgColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 32, color: fgColor.withOpacity(0.7)),
              const SizedBox(height: 12),
            ],
            Text(
              count.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: fgColor.withOpacity(0.7),
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    trendPositive ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: trendPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: TextStyle(
                      color: trendPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
