import 'package:flutter/material.dart';
import '../forms/quantity_selector.dart';
import 'price_tag.dart';

class ReusableCartItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final void Function(int)? onQuantityChanged;
  final VoidCallback? onRemove;

  const ReusableCartItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.onQuantityChanged,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(width:88, height:88, child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(color: Colors.grey[200], child: Icon(Icons.image)))),
            SizedBox(width:8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height:4),
              PriceTag(price: price),
              SizedBox(height:8),
              Row(children: [
                QuantitySelector(quantity: quantity, onChanged: onQuantityChanged),
                SizedBox(width:12),
                TextButton.icon(onPressed: onRemove, icon: Icon(Icons.delete_outline), label: Text('Remove'))
              ])
            ]))
          ],
        ),
      ),
    );
  }
}
