import 'package:flutter/material.dart';

import 'custom_item_drawer.dart';

class CustomDrawerItemSetting extends CustomItemDrawer {
  final String? note;
  final String title;
  final Widget child;
  final IconData? icon;
  final String subtitle;
  final bool isDeprecated;

  CustomDrawerItemSetting({
    this.note,
    required this.title,
    required this.child,
    this.icon,
    required this.subtitle,
    this.isDeprecated = false,
  });
}
