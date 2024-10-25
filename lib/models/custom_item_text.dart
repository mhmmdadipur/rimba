import 'package:flutter/material.dart';

class CustomItemText {
  final String text;
  final TextStyle? style;
  final bool isBold;

  CustomItemText({
    required this.text,
    this.style,
    this.isBold = false,
  }) : assert(isBold ? style == null : true);
}
