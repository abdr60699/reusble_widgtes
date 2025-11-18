
// reusable_slider_input.dart
// Slider with value display and optional input field
import 'package:flutter/material.dart';

typedef SliderValueChanged = void Function(double v);

class ReusableSliderInput extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final SliderValueChanged? onChanged;
  final int divisions;
  final String? label;

  const ReusableSliderInput({
    Key? key,
    this.min = 0,
    this.max = 100,
    required this.value,
    this.onChanged,
    this.divisions = 0,
    this.label,
  }) : super(key: key);

  @override
  State<ReusableSliderInput> createState() => _ReusableSliderInputState();
}

class _ReusableSliderInputState extends State<ReusableSliderInput> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) Text(widget.label!, style: Theme.of(context).textTheme.bodyMedium),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions > 0 ? widget.divisions : null,
                value: _value,
                onChanged: (v) {
                  setState(() => _value = v);
                  widget.onChanged?.call(v);
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 64,
              child: Text(_value.toStringAsFixed( (widget.max - widget.min) > 100 ? 0 : 1 ), textAlign: TextAlign.right),
            ),
          ],
        ),
      ],
    );
  }
}
