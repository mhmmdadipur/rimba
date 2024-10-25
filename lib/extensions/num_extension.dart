part of 'extensions.dart';

extension NumExtension on num? {
  String get toDisplay => this == null ? '-' : this!.toStringAsFixed(1);

  String formatNumber() => toString().padLeft(2, '0');
}
