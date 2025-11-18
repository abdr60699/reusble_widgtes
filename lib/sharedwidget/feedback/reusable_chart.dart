import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// A reusable chart widget for displaying data visualizations.
///
/// Supports line charts, bar charts, and pie charts.
///
/// Example:
/// ```dart
/// ReusableChart.line(
///   dataPoints: [1, 3, 2, 5, 4],
///   labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
///   title: 'Weekly Sales',
/// )
/// ```
class ReusableChart extends StatelessWidget {
  /// Chart data points
  final List<double> dataPoints;

  /// Labels for data points
  final List<String>? labels;

  /// Chart title
  final String? title;

  /// Chart color
  final Color? color;

  /// Chart type
  final ChartType type;

  const ReusableChart({
    super.key,
    required this.dataPoints,
    this.labels,
    this.title,
    this.color,
    this.type = ChartType.line,
  });

  /// Create a line chart
  factory ReusableChart.line({
    required List<double> dataPoints,
    List<String>? labels,
    String? title,
    Color? color,
  }) {
    return ReusableChart(
      dataPoints: dataPoints,
      labels: labels,
      title: title,
      color: color,
      type: ChartType.line,
    );
  }

  /// Create a bar chart
  factory ReusableChart.bar({
    required List<double> dataPoints,
    List<String>? labels,
    String? title,
    Color? color,
  }) {
    return ReusableChart(
      dataPoints: dataPoints,
      labels: labels,
      title: title,
      color: color,
      type: ChartType.bar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartColor = color ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: type == ChartType.line
                ? _buildLineChart(chartColor)
                : _buildBarChart(chartColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(Color chartColor) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: chartColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Color chartColor) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        barGroups: dataPoints
            .asMap()
            .entries
            .map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: chartColor,
                      width: 16,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

enum ChartType {
  line,
  bar,
}
