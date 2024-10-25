import 'package:flutter/material.dart';

class CustomItemNavbar {
  final String id;
  final String? slug;
  final IconData? selectedIcon, unselectedIcon;
  final String label;

  CustomItemNavbar({
    required this.id,
    required this.label,
    this.selectedIcon,
    this.unselectedIcon,
    this.slug,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is CustomItemNavbar &&
        other.runtimeType == runtimeType &&
        other.id == id);
  }

  @override
  int get hashCode => Object.hash(id, label);
}
