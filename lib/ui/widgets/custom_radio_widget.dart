part of 'widgets.dart';

class CustomRadioWidget<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final double height;
  final bool isExpanded;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomRadioWidget({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.height = 40,
    this.isExpanded = false,
    this.style,
    this.overflow,
    this.maxLines,
  });

  @override
  State<CustomRadioWidget<T>> createState() => CustomRadioWidgetState<T>();
}

class CustomRadioWidgetState<T> extends State<CustomRadioWidget<T>> {
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget label = Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        widget.label,
        overflow: widget.overflow,
        maxLines: widget.maxLines,
        style: const TextStyle().copyWithTextStyle(widget.style),
      ),
    );

    return InkWell(
      onTap: () {
        if (widget.onChanged != null) widget.onChanged!(widget.value);
      },
      splashColor: _themeController.primaryColor200.value.withOpacity(.1),
      highlightColor: _themeController.primaryColor200.value.withOpacity(.1),
      borderRadius:
          BorderRadius.circular(_themeController.getThemeBorderRadius(10)),
      child: SizedBox(
        height: widget.height,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Radio(
                value: widget.value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
                hoverColor: Colors.transparent,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.grey.withOpacity(.32);
                  } else if (states.contains(WidgetState.selected)) {
                    return _themeController.primaryColor200.value;
                  }
                  return _themeController.getPrimaryTextColor.value;
                }),
              ),
            ),
            Visibility(
              visible: !widget.isExpanded,
              child: Flexible(child: label),
            ),
            Visibility(
              visible: widget.isExpanded,
              child: Expanded(child: label),
            ),
          ],
        ),
      ),
    );
  }
}
