import 'package:flutter/material.dart';

enum BannerPosition { top, bottom }

class ReusableBanner extends StatelessWidget {
  final String message;
  final BannerPosition position;
  final Color? backgroundColor;
  final VoidCallback? onClose;

  const ReusableBanner({
    Key? key,
    required this.message,
    this.position = BannerPosition.top,
    this.backgroundColor,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final banner = Material(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        child: Row(
          children: [
            Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
            if (onClose != null)
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
          ],
        ),
      ),
    );

    return Positioned(
      top: position == BannerPosition.top ? 0 : null,
      bottom: position == BannerPosition.bottom ? 0 : null,
      left: 0,
      right: 0,
      child: banner,
    );
  }
}
