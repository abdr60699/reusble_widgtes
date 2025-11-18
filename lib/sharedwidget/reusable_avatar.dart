
// reusable_avatar.dart
// Avatar widget with online/offline/away status indicator
import 'package:flutter/material.dart';

enum AvatarStatus { online, offline, away, doNotDisturb, unknown }

class ReusableAvatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final String? initials;
  final AvatarStatus status;
  final Color? backgroundColor;
  final Color? statusColor;
  final bool showStatus;

  const ReusableAvatar({
    Key? key,
    this.radius = 24,
    this.imageUrl,
    this.initials,
    this.status = AvatarStatus.unknown,
    this.backgroundColor,
    this.statusColor,
    this.showStatus = true,
  }) : super(key: key);

  Color _statusColor(BuildContext context) {
    if (statusColor != null) return statusColor!;
    switch (status) {
      case AvatarStatus.online:
        return Colors.green;
      case AvatarStatus.away:
        return Colors.orange;
      case AvatarStatus.doNotDisturb:
        return Colors.red;
      case AvatarStatus.offline:
        return Colors.grey;
      case AvatarStatus.unknown:
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primaryContainer;

    final avatar = (imageUrl != null && imageUrl!.isNotEmpty)
        ? CircleAvatar(radius: radius, backgroundImage: NetworkImage(imageUrl!), backgroundColor: bg)
        : CircleAvatar(
            radius: radius,
            backgroundColor: bg,
            child: initials != null ? Text(initials!, style: TextStyle(fontSize: radius * 0.6)) : null,
          );

    if (!showStatus || status == AvatarStatus.unknown) return avatar;

    return Stack(
      alignment: Alignment.center,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: radius * 0.5,
            height: radius * 0.5,
            decoration: BoxDecoration(
              color: _statusColor(context),
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
