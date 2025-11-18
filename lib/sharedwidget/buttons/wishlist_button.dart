import 'package:flutter/material.dart';

class WishlistButton extends StatelessWidget {
  final bool isWishlisted;
  final void Function(bool)? onChanged;

  const WishlistButton({Key? key, required this.isWishlisted, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isWishlisted ? Icons.favorite : Icons.favorite_border, color: isWishlisted ? Colors.red : Colors.grey),
      onPressed: () => onChanged?.call(!isWishlisted),
      tooltip: isWishlisted ? 'Remove from wishlist' : 'Add to wishlist',
    );
  }
}
