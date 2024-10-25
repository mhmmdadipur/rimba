part of 'widgets.dart';

class CustomButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final Widget? child;
  final Color? color;
  final Color? highlightColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final String? label;
  final double? width;
  final double? height;
  final TextStyle? style;
  final bool enable;
  final List<BoxShadow>? boxShadow;
  final BoxDecoration? decoration;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  const CustomButton({
    super.key,
    this.onTap,
    this.child,
    this.color,
    this.highlightColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.label,
    this.style,
    this.boxShadow,
    this.width,
    this.height,
    this.enable = true,
    this.decoration,
    this.constraints,
    this.alignment,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child ??
        Center(
          child: Text(widget.label ?? 'Label',
              style: const TextStyle(color: SharedValue.textDarkColor200)
                  .copyWithTextStyle(widget.style)),
        );

    return InkWell(
      onTap: widget.enable ? widget.onTap : null,
      splashColor:
          (widget.highlightColor ?? _themeController.primaryColor200.value)
              .withOpacity(.1),
      highlightColor:
          (widget.highlightColor ?? _themeController.primaryColor200.value)
              .withOpacity(.1),
      borderRadius: widget.borderRadius ??
          BorderRadius.circular(_themeController.getThemeBorderRadius(8)),
      child: Container(
        constraints: widget.constraints,
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding ?? const EdgeInsets.all(14),
        decoration: BoxDecoration(
                color: widget.color ??
                    (widget.enable
                        ? _themeController.primaryColor200.value
                        : SharedValue.textDarkColor100),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                        _themeController.getThemeBorderRadius(8)),
                boxShadow: widget.boxShadow)
            .copyWithBoxDecoration(widget.decoration),
        child: child,
      ),
    );
  }
}
