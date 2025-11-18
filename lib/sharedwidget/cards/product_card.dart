import 'package:flutter/material.dart';
import 'price_tag.dart';
import 'wishlist_button.dart';

class ReusableProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final bool isWishlisted;
  final void Function()? onTap;
  final void Function(bool)? onWishlistToggle;

  const ReusableProductCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4/3,
              child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___)=>Container(color: Colors.grey[200], child: Icon(Icons.image, size: 48))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height:4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ])),
                Column(children: [
                  PriceTag(price: price),
                  SizedBox(height:4),
                  WishlistButton(isWishlisted: isWishlisted, onChanged: onWishlistToggle),
                ])
              ]),
            )
          ],
        ),
      ),
    );
  }
}
