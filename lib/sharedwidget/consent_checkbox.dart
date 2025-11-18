import 'package:flutter/material.dart';

class ReusableConsentCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;
  final String label;

  const ReusableConsentCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(child: Text(label)),
      ],
    );
  }
}
