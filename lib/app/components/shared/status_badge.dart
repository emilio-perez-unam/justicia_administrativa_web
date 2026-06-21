import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Widget child;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeContent: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(4),
        elevation: 0,
      ),
      position: badges.BadgePosition.topEnd(top: -10, end: -10),
      child: child,
    );
  }
}
