
// reusable_rating.dart
// Star rating widget (read-only or interactive)
import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class ReusableRating extends StatelessWidget {
  final double rating; // current rating, can be fractional like 3.5
  final int itemCount;
  final double size;
  final Color? filledColor;
  final Color? unfilledColor;
  final bool readOnly;
  final RatingChangeCallback? onChanged;
  final bool allowHalfRating;

  const ReusableRating({
    Key? key,
    required this.rating,
    this.itemCount = 5,
    this.size = 24,
    this.filledColor,
    this.unfilledColor,
    this.readOnly = true,
    this.onChanged,
    this.allowHalfRating = true,
  }) : super(key: key);

  Widget _buildStar(BuildContext context, int index) {
    final filledColorFinal = filledColor ?? Theme.of(context).colorScheme.primary;
    final unfilledColorFinal = unfilledColor ?? Theme.of(context).disabledColor;

    double starValue = index + 1.0;
    Icon icon;
    if (rating >= starValue) {
      icon = Icon(Icons.star, size: size, color: filledColorFinal);
    } else if (allowHalfRating && rating + 0.5 >= starValue) {
      icon = Icon(Icons.star_half, size: size, color: filledColorFinal);
    } else {
      icon = Icon(Icons.star_border, size: size, color: unfilledColorFinal);
    }

    if (readOnly) return icon;

    return InkResponse(
      onTap: () {
        onChanged?.call(starValue);
      },
      onDoubleTap: () {
        if (allowHalfRating) {
          onChanged?.call(starValue - 0.5);
        } else {
          onChanged?.call(starValue);
        }
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (i) => _buildStar(context, i)),
    );
  }
}
