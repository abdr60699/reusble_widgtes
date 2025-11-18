import 'package:flutter/material.dart';

class ReusableSpeedDial extends StatefulWidget {
  final IconData icon;
  final List<SpeedDialItem> children;

  const ReusableSpeedDial({
    super.key,
    required this.icon,
    required this.children,
  });

  @override
  State<ReusableSpeedDial> createState() => _ReusableSpeedDialState();
}

class _ReusableSpeedDialState extends State<ReusableSpeedDial>
    with SingleTickerProviderStateMixin {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (open)
          ...widget.children.asMap().entries.map(
                (e) => Positioned(
                  bottom: 70.0 * (e.key + 1),
                  right: 10,
                  child: FloatingActionButton.small(
                    heroTag: e.value.label,
                    onPressed: e.value.onTap,
                    child: Icon(e.value.icon),
                  ),
                ),
              ),
        FloatingActionButton(
          child: Icon(open ? Icons.close : widget.icon),
          onPressed: () => setState(() => open = !open),
        )
      ],
    );
  }
}

class SpeedDialItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  SpeedDialItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
