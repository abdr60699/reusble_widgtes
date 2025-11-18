
// reusable_date_range_picker.dart
// Date range selection wrapper using showDateRangePicker
import 'package:flutter/material.dart';

typedef DateRangeSelected = void Function(DateTimeRange range);

class ReusableDateRangePicker extends StatefulWidget {
  final DateTimeRange? initialRange;
  final DateRangeSelected? onSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ReusableDateRangePicker({
    Key? key,
    this.initialRange,
    this.onSelected,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  State<ReusableDateRangePicker> createState() => _ReusableDateRangePickerState();
}

class _ReusableDateRangePickerState extends State<ReusableDateRangePicker> {
  DateTimeRange? _range;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(now.year - 5),
      lastDate: widget.lastDate ?? DateTime(now.year + 5),
      initialDateRange: _range,
    );
    if (picked != null) {
      setState(() => _range = picked);
      widget.onSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _range == null
        ? 'Choose date range'
        : '${_range!.start.toLocal().toShortDateString()} - ${_range!.end.toLocal().toShortDateString()}';

    return ElevatedButton(
      onPressed: _pickRange,
      child: Text(label),
    );
  }
}

extension _DateFormatting on DateTime {
  String toShortDateString() {
    return '${this.year}-${this.month.toString().padLeft(2,'0')}-${this.day.toString().padLeft(2,'0')}';
  }
}
