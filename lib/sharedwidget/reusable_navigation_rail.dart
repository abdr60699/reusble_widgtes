import 'package:flutter/material.dart';

class ReusableNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationRailDestination> destinations;
  final ValueChanged<int> onSelect;

  const ReusableNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      labelType: NavigationRailLabelType.all,
      destinations: destinations,
    );
  }
}
