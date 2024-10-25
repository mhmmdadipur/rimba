import 'package:flutter/material.dart';

class CustomItemDropdown {
  final String id;
  final String label;
  final IconData icon;
  final Widget? child;
  final GestureTapCallback? onTap;

  CustomItemDropdown({
    required this.id,
    required this.label,
    required this.icon,
    this.child,
    this.onTap,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is CustomItemDropdown &&
        other.runtimeType == runtimeType &&
        other.label == label);
  }

  @override
  int get hashCode => Object.hash(id, label);
}
