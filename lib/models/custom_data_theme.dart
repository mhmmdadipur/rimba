import 'package:flutter/material.dart';

class CustomDataTheme {
  final String name;
  final Color primaryColor100;
  final Color primaryColor200;
  final Color primaryColor300;
  final Color secondaryColor100;
  final Color secondaryColor200;

  CustomDataTheme({
    required this.name,
    required this.primaryColor100,
    required this.primaryColor200,
    required this.primaryColor300,
    required this.secondaryColor100,
    required this.secondaryColor200,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is CustomDataTheme &&
        other.runtimeType == runtimeType &&
        other.name == name);
  }

  @override
  int get hashCode => Object.hash(name, primaryColor200);
}
