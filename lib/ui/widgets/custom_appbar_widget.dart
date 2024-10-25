part of 'widgets.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? titleText;
  final Widget? title;
  final GestureTapCallback? onTap;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final Color? componentColor;
  final bool canReturn;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  // double appBarHeight = AppBar().preferredSize.height;

  const CustomAppBarWidget({
    super.key,
    this.titleText,
    this.title,
    this.onTap,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.titleTextStyle,
    this.componentColor,
    this.canReturn = true,
    this.centerTitle = true,
    this.bottom,
  });

  static final ThemeController _themeController = Get.find();
  static final UserController _userController = Get.find();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  static Future<void> _getLogoutAction() async {
    var response = await SharedWidget.renderDefaultDialog(
        icon: IconlyLight.logout,
        title: 'Are you sure?',
        contentText: 'Are you sure you want to exit the application?');

    if (response != null) await _userController.logout();
  }

  static Widget renderAppbarButton({
    required IconData icon,
    String? badge,
    required GestureTapCallback? onTap,
    Color? iconColor,
    Color? buttonColor,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 56, height: 56),
      child: Center(
        child: Badge(
          isLabelVisible: badge != null,
          label: Text(SharedMethod.valuePrettier(badge)),
          backgroundColor: Colors.red.shade700,
          child: CustomButton(
            width: 35,
            height: 35,
            onTap: onTap,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor ??
                  _themeController.getSecondaryTextColor.value.withOpacity(.1),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(8),
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color: iconColor ?? _themeController.getSecondaryTextColor.value,
            ),
          ),
        ),
      ),
    );
  }

  static Widget renderCircleAvatar({
    Color? iconColor,
    Color? buttonColor,
  }) {
    List<CustomItemDropdown> menusDropdown = [
      if (_userController.user.isNotRxNull)
        CustomItemDropdown(
          id: 'profile',
          label: 'Informasi Pribadi',
          icon: IconlyLight.profile,
          onTap: () => Get.toNamed(Routes.myAccount),
        ),
      CustomItemDropdown(
        id: 'privacy',
        label: 'Kebijakan Privasi',
        icon: IconlyLight.shield_done,
        onTap: () => Get.toNamed(Routes.maintenance),
      ),
      CustomItemDropdown(
        id: 'help',
        label: 'Bantuan',
        icon: IconlyLight.chat,
        onTap: () => Get.toNamed(Routes.maintenance),
      ),
      CustomItemDropdown(
        id: 'profile',
        label: 'Syarat & Ketentuan',
        icon: Iconsax.document,
        onTap: () => Get.toNamed(Routes.maintenance),
      ),
      if (_userController.user.isNotRxNull)
        CustomItemDropdown(
          id: 'logout',
          label: 'Logout',
          icon: IconlyLight.logout,
          onTap: () async => await _getLogoutAction(),
        ),
      if (_userController.user.isRxNull)
        CustomItemDropdown(
          id: 'login',
          label: 'Login',
          icon: IconlyLight.login,
          onTap: () => Get.toNamed(Routes.login),
        ),
    ];

    return CustomDropdownWidget<CustomItemDropdown>(
      isExpanded: true,
      dropdownWidth: (Get.width - (8 * 2)) * .6,
      onChanged: (value) =>
          (value != null && value.onTap != null) ? value.onTap!() : null,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 8),
      customButton: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 40, height: 56),
        child: Center(
          child: CustomButton(
            width: 35,
            height: 35,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: buttonColor ??
                    _themeController.getSecondaryTextColor.value
                        .withOpacity(.1),
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(8))),
            child: Icon(
              IconlyBold.user_2,
              size: 22,
              color: iconColor ?? _themeController.getSecondaryTextColor.value,
            ),
          ),
        ),
      ),
      items: List.generate(
        menusDropdown.length,
        (i) => DropdownMenuItem<CustomItemDropdown>(
          value: menusDropdown[i],
          child: Row(
            children: [
              Icon(menusDropdown[i].icon, size: 20),
              const SizedBox(width: 15),
              Text(
                menusDropdown[i].label,
                style: TextStyle(
                    fontSize: 12,
                    color: _themeController.getPrimaryTextColor.value),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget renderFusionButton(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !CustomResponsiveWidget.isDesktop(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            color: Colors.transparent,
            padding: const EdgeInsets.all(5),
            child: Icon(
                CustomResponsiveWidget.isMobile(context)
                    ? EvaIcons.arrowIosBack
                    : MdiIcons.menu,
                color: _themeController.getPrimaryTextColor.value),
            onTap: () {
              if (CustomResponsiveWidget.isMobile(context)) {
                Get.back();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading ??
        (canReturn
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onTap: onTap ?? () => Get.back(),
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(5),
                  child: Icon(EvaIcons.arrowIosBack,
                      color: componentColor ??
                          _themeController.getPrimaryTextColor.value),
                ),
              )
            : const SizedBox(width: SharedValue.defaultPadding));

    return Obx(
      () => AppBar(
        bottom: bottom,
        centerTitle: centerTitle,
        titleSpacing: 0,
        title: title ??
            (titleText != null ? Text(titleText ?? '') : const SizedBox()),
        titleTextStyle: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: componentColor ??
                    _themeController.getPrimaryTextColor.value)
            .copyWithTextStyle(titleTextStyle),
        automaticallyImplyLeading: canReturn,
        backgroundColor:
            backgroundColor ?? _themeController.getPrimaryBackgroundColor.value,
        leading: leadingWidget,
        leadingWidth: canReturn ? null : SharedValue.defaultPadding,
        actions: actions,
      ),
    );
  }
}
