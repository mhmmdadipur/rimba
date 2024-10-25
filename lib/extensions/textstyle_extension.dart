part of 'extensions.dart';

extension TextStyleExtension on TextStyle {
  TextStyle copyWithTextStyle(TextStyle? anotherTextStyle) {
    return copyWith(
      background: anotherTextStyle?.background,
      backgroundColor: anotherTextStyle?.backgroundColor,
      color: anotherTextStyle?.color,
      debugLabel: anotherTextStyle?.debugLabel,
      decoration: anotherTextStyle?.decoration,
      decorationColor: anotherTextStyle?.backgroundColor,
      decorationStyle: anotherTextStyle?.decorationStyle,
      decorationThickness: anotherTextStyle?.decorationThickness,
      fontFamily: anotherTextStyle?.fontFamily,
      fontFamilyFallback: anotherTextStyle?.fontFamilyFallback,
      fontFeatures: anotherTextStyle?.fontFeatures,
      fontSize: anotherTextStyle?.fontSize,
      fontStyle: anotherTextStyle?.fontStyle,
      fontVariations: anotherTextStyle?.fontVariations,
      fontWeight: anotherTextStyle?.fontWeight,
      foreground: anotherTextStyle?.foreground,
      height: anotherTextStyle?.height,
      inherit: anotherTextStyle?.inherit,
      leadingDistribution: anotherTextStyle?.leadingDistribution,
      letterSpacing: anotherTextStyle?.letterSpacing,
      locale: anotherTextStyle?.locale,
      overflow: anotherTextStyle?.overflow,
      shadows: anotherTextStyle?.shadows,
      textBaseline: anotherTextStyle?.textBaseline,
      wordSpacing: anotherTextStyle?.wordSpacing,
    );
  }
}
