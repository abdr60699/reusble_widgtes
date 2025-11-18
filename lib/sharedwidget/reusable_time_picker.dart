
// reusable_time_picker.dart
// Lightweight time picker wrapper
import 'package:flutter/material.dart';

typedef TimeSelected = void Function(TimeOfDay time);

class ReusableTimePicker extends StatelessWidget {
  final TimeOfDay? initialTime;
  final TimeSelected? onTimeSelected;
  final bool use24HourFormat;

  const ReusableTimePicker({
    Key? key,
    this.initialTime,
    this.onTimeSelected,
    this.use24HourFormat = false,
  }) : super(key: key);

  Future<void> _show(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? now,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24HourFormat),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked != null) onTimeSelected?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _show(context),
      icon: const Icon(Icons.access_time),
      label: const Text('Pick time'),
    );
  }
}
