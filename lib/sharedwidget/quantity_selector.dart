import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int min;
  final int max;
  final void Function(int)? onChanged;

  const QuantitySelector({Key? key, required this.quantity, this.onChanged, this.min = 1, this.max = 999}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width:32,
          height:32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: quantity>min ? () => onChanged?.call(quantity-1) : null,
            child: Icon(Icons.remove, size:18),
          ),
        ),
        SizedBox(width:8),
        Text(quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width:8),
        SizedBox(
          width:32,
          height:32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: quantity<max ? () => onChanged?.call(quantity+1) : null,
            child: Icon(Icons.add, size:18),
          ),
        ),
      ],
    );
  }
}
