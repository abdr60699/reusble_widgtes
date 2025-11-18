import 'package:flutter/material.dart';

/// A reusable calendar widget for date selection and display.
///
/// Provides a simple calendar view with customizable appearance
/// and date selection functionality.
///
/// Example:
/// ```dart
/// ReusableCalendar(
///   selectedDate: DateTime.now(),
///   onDateSelected: (date) => print('Selected: $date'),
///   minDate: DateTime(2020),
///   maxDate: DateTime(2030),
/// )
/// ```
class ReusableCalendar extends StatefulWidget {
  /// Currently selected date
  final DateTime? selectedDate;

  /// Callback when date is selected
  final Function(DateTime) onDateSelected;

  /// Minimum selectable date
  final DateTime? minDate;

  /// Maximum selectable date
  final DateTime? maxDate;

  /// Highlighted dates (special dates to mark)
  final List<DateTime>? highlightedDates;

  /// Color for highlighted dates
  final Color? highlightColor;

  const ReusableCalendar({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.minDate,
    this.maxDate,
    this.highlightedDates,
    this.highlightColor,
  });

  @override
  State<ReusableCalendar> createState() => _ReusableCalendarState();
}

class _ReusableCalendarState extends State<ReusableCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month/Year header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                '${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
        ),
        // Calendar grid
        Padding(
          padding: const EdgeInsets.all(16),
          child: CalendarDatePicker(
            initialDate: widget.selectedDate ?? DateTime.now(),
            firstDate: widget.minDate ?? DateTime(1900),
            lastDate: widget.maxDate ?? DateTime(2100),
            currentDate: _focusedMonth,
            onDateChanged: widget.onDateSelected,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
