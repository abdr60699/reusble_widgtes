import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final String? currencySymbol;
  final TextStyle? style;

  const PriceTag({Key? key, required this.price, this.currencySymbol = '₹', this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '\${currencySymbol}\${price.toStringAsFixed(2)}',
      style: style ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
