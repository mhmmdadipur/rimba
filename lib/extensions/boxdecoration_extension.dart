part of 'extensions.dart';

extension BoxDecorationExtension on BoxDecoration {
  BoxDecoration copyWithBoxDecoration(BoxDecoration? anotherBoxDecoration) {
    return copyWith(
      backgroundBlendMode: anotherBoxDecoration?.backgroundBlendMode,
      border: anotherBoxDecoration?.border,
      borderRadius: anotherBoxDecoration?.borderRadius,
      boxShadow: anotherBoxDecoration?.boxShadow,
      color: anotherBoxDecoration?.color,
      gradient: anotherBoxDecoration?.gradient,
      image: anotherBoxDecoration?.image,
      shape: anotherBoxDecoration?.shape,
    );
  }
}
