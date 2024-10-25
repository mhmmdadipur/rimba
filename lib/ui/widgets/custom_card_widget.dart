part of 'widgets.dart';

class CustomCardWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final BoxDecoration? decoration;

  const CustomCardWidget({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(SharedValue.defaultPadding),
    this.decoration,
  });

  static final ThemeController _themeController = Get.find();

  static Widget renderRequirementsCard({
    String title = 'Ensure that these requirements are met',
    String subtitle = 'Please fill in all available fields',
    Color color = Colors.orange,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: Get.width,
      margin: margin,
      padding: const EdgeInsets.all(SharedValue.defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(
          _themeController.getThemeBorderRadius(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.w500, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: _themeController.getSecondaryBackgroundColor.value,
          boxShadow: _themeController.getShadowProfile(mode: 2),
          borderRadius: BorderRadius.circular(
            _themeController.getThemeBorderRadius(10),
          ),
        ).copyWithBoxDecoration(decoration),
        child: child,
      ),
    );
  }
}
