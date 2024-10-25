part of 'widgets.dart';

class CustomNavbarWidget extends StatefulWidget {
  const CustomNavbarWidget({
    super.key,
  });

  @override
  State<CustomNavbarWidget> createState() => _CustomNavbarWidgetState();
}

class _CustomNavbarWidgetState extends State<CustomNavbarWidget> {
  final ThemeController _themeController = Get.find();
  final MainController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 80,
          mainAxisSpacing: SharedValue.defaultPadding,
          crossAxisSpacing: SharedValue.defaultPadding,
          crossAxisCount: CustomResponsiveWidget.value(context,
              whenMobile: 3, whenTablet: 4, whenDesktop: 5),
        ),
        children: List.generate(
          _mainController.navbarMenu.length,
          (index) => generateItemNavbar(index),
        ),
      ),
    );
  }

  Widget generateItemNavbar(int index) {
    CustomItemNavbar item = _mainController.navbarMenu[index];

    return InkWell(
      onTap: () {
        _mainController.selectedItemNavbarId(item.id);
        Get.offAllNamed(item.slug ?? Routes.maintenance);
      },
      borderRadius: BorderRadius.circular(8),
      highlightColor:
          _themeController.getPrimaryBackgroundColor.value.withOpacity(.2),
      splashColor:
          _themeController.getPrimaryBackgroundColor.value.withOpacity(.1),
      child: AnimatedContainer(
        margin: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _mainController.selectedItemNavbarId.value == item.id
                    ? item.selectedIcon
                    : item.unselectedIcon,
                size: 21,
                color: _mainController.selectedItemNavbarId.value == item.id
                    ? _themeController.primaryColor200.value
                    : _themeController.getSecondaryTextColor.value,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: _mainController.selectedItemNavbarId.value == item.id
                      ? _themeController.primaryColor200.value
                      : _themeController.getSecondaryTextColor.value,
                  fontWeight:
                      _mainController.selectedItemNavbarId.value == item.id
                          ? FontWeight.w600
                          : FontWeight.w500,
                ),
                child: Text(item.label, maxLines: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
