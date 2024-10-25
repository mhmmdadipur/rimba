import 'package:flutter/material.dart';

class CustomItemTabbar {
  final String label;
  final IconData icon;
  int? totalNotification;

  CustomItemTabbar(
      {required this.label, required this.icon, this.totalNotification});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is CustomItemTabbar &&
        other.runtimeType == runtimeType &&
        other.label == label);
  }

  @override
  int get hashCode => Object.hash(label, totalNotification ?? 0);
}
