import 'package:flutter/material.dart';

class CustomItemMenu {
  final String name;
  final String? badge;
  final Color? color;
  final IconData? icon;
  final String? svgAsset;
  final double? iconSize;
  final GestureTapCallback? onTap;

  CustomItemMenu({
    required this.name,
    this.badge,
    this.color,
    this.icon,
    this.svgAsset,
    this.iconSize,
    this.onTap,
  });
}
