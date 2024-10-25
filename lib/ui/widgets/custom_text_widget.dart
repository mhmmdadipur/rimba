part of 'widgets.dart';

class CustomTextWidget extends StatelessWidget {
  final List<CustomItemText> texts;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  CustomTextWidget({
    super.key,
    required this.texts,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
    this.textDirection,
  });

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: List.generate(
          texts.length,
          (index) => renderTextSpan(index),
        ),
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textDirection: textDirection,
      style: const TextStyle().copyWithTextStyle(style),
    );
  }

  TextSpan renderTextSpan(int index) {
    CustomItemText data = texts[index];

    TextStyle? style = data.isBold
        ? TextStyle(
                fontWeight: FontWeight.w600,
                color: _themeController.primaryColor300.value)
            .copyWithTextStyle(data.style)
        : data.style;

    return TextSpan(text: data.text, style: style);
  }
}
