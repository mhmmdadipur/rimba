part of 'shared.dart';

class SharedWidget {
  static final ThemeController _themeController = Get.find();

  static void renderDefaultSnackBar({
    String? title,
    required String message,
    bool isError = false,
    IconData? icon,
    Color? color,
    Duration? duration = const Duration(seconds: 3),
  }) {
    title ??= isError ? 'Error' : "Success";
    color ??= isError ? Colors.red : Colors.teal;
    icon ??= isError
        ? CupertinoIcons.xmark_circle
        : CupertinoIcons.checkmark_alt_circle;

    Get.rawSnackbar(
      maxWidth: 500,
      padding: EdgeInsets.zero,
      titleText: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
        child: Column(
          children: [
            PaddingRow(
              padding: const EdgeInsets.all(10),
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
                Text(
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const SizedBox(width: 10),
                InkWell(
                    onTap: () => Get.closeCurrentSnackbar(),
                    child: const Icon(EvaIcons.close, color: Colors.white))
              ],
            ),
            Divider(color: Colors.white.withOpacity(.6), height: 0),
          ],
        ),
      ),
      messageText: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Text(message,
              style: const TextStyle(fontSize: 13, color: Colors.white))),
      backgroundColor: Color.alphaBlend(color.withAlpha(200), Colors.white),
      snackPosition: _themeController.snackPosition.value,
      margin: const EdgeInsets.all(8),
      duration: duration,
      borderRadius: 8,
    );
  }

  static Widget renderDefaultLoading({
    bool isLoading = true,
  }) {
    return isLoading
        ? Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black.withOpacity(.5),
            child: Center(
              child: SizedBox(
                width: Get.height * .15,
                height: Get.height * .15,
                child: const LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: [Colors.white],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  static Future<dynamic> renderDefaultDialog({
    required IconData icon,
    bool barrierDismissible = true,
    EdgeInsetsGeometry? iconPadding,
    Color? iconColor,
    required String title,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleTextStyle,
    Widget? content,
    String contentText =
        'This is the default dummy text, you can change this text with your preferred text.',
    EdgeInsetsGeometry? contentPadding,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    Color? backgroundColor,
    Color? backgroundIconColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    String? semanticLabel,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    bool showSubmitButton = true,
    String onSubmitText = 'Submit',
    GestureTapCallback? onSubmit,
    bool showCancelButton = true,
    String onCancelText = 'Cancel',
    GestureTapCallback? onCancel,
  }) async {
    return Get.dialog(
      AlertDialog(
        icon: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                color: backgroundIconColor ??
                    _themeController.primaryColor200.value,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        _themeController.getThemeBorderRadius(15)))),
            child: Icon(icon, size: 70, color: Colors.white)),
        iconPadding: EdgeInsets.zero,
        iconColor: iconColor,
        titlePadding: titlePadding ?? const EdgeInsets.fromLTRB(10, 20, 10, 10),
        content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: content ??
                Text(contentText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13))),
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
        contentTextStyle: contentTextStyle,
        actionsPadding: actionsPadding ??
            (showCancelButton || showSubmitButton
                ? const EdgeInsets.all(10)
                : const EdgeInsets.only(top: 10)),
        actionsAlignment: actionsAlignment,
        actionsOverflowAlignment: actionsOverflowAlignment,
        actionsOverflowDirection: actionsOverflowDirection,
        actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
        buttonPadding: buttonPadding,
        backgroundColor:
            backgroundColor ?? _themeController.getPrimaryBackgroundColor.value,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        semanticLabel: semanticLabel,
        shape: shape ??
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(15))),
        alignment: alignment,
        title: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: _themeController.getPrimaryTextColor.value)
                .copyWithTextStyle(titleTextStyle)),
        actions: [
          Row(
            children: [
              Visibility(
                visible: showCancelButton,
                child: Expanded(
                  child: CustomButton(
                    height: 35,
                    label: onCancelText,
                    color: Colors.red[300],
                    padding: const EdgeInsets.all(0),
                    onTap: onCancel ??
                        () {
                          if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                          Get.back();
                        },
                  ),
                ),
              ),
              Visibility(
                  visible: showSubmitButton && showCancelButton,
                  child: const SizedBox(width: 10)),
              Visibility(
                visible: showSubmitButton,
                child: Expanded(
                  child: CustomButton(
                    height: 35,
                    label: onSubmitText,
                    color: Colors.teal[300],
                    padding: const EdgeInsets.all(0),
                    style: const TextStyle(fontSize: 13),
                    onTap: onSubmit ??
                        () {
                          if (Get.isSnackbarOpen) Get.closeAllSnackbars();
                          Get.back(result: true);
                        },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> renderNoPermissionDialog() async {
    return await SharedWidget.renderDefaultDialog(
      icon: MdiIcons.shieldRemove,
      title: 'Akses Dilarang',
      onCancelText: 'Kembali',
      showSubmitButton: false,
      backgroundIconColor: Colors.red[300],
      contentText: 'Anda tidak memiliki perizinan untuk menggunakan fitur ini.',
    );
  }

  static Future<dynamic> renderDefaultBottomModal({
    required String titleText,
    Widget? title,
    TextStyle? titleTextStyle,
    String? subtitle =
        'This is the default dummy text, you can change this text with your preferred text.',
    TextStyle? subtitleTextStyle,
    Color? backgroundColor,
    bool isExpanded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    double? spacingScrolledContent,
    List<Widget> content = const [],
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    EdgeInsetsGeometry paddingTitle =
        const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding),
    EdgeInsetsGeometry paddingContent = EdgeInsets.zero,
  }) async {
    Widget child = PaddingColumn(
        padding: paddingContent,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: content);

    Widget header = Container(
      width: Get.width,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? _themeController.getPrimaryBackgroundColor.value,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(_themeController.getThemeBorderRadius(15))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3,
            width: Get.width * .25,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20)),
          ),
          Padding(
            padding: paddingTitle,
            child: title ??
                Text(
                  titleText,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                          .copyWithTextStyle(titleTextStyle),
                ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: subtitle != null,
            child: Padding(
              padding: paddingTitle,
              child: Text(subtitle ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                          fontSize: 12,
                          color: _themeController.getSecondaryTextColor.value)
                      .copyWithTextStyle(subtitleTextStyle)),
            ),
          ),
          isScrollControlled
              ? child
              : isExpanded
                  ? Expanded(child: child)
                  : child,
        ],
      ),
    );

    return Get.bottomSheet(
      isScrollControlled
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ///functions to provide distance between the top border and the widget
                  ///when the content is full, and can still close bottomSheet if pressed
                  InkWell(
                      onTap: () => Get.back(),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                          height: spacingScrolledContent ?? 100,
                          width: Get.width)),
                  header
                ],
              ),
            )
          : header,
      elevation: 0,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
    );
  }

  static Future<dynamic> renderSettingsBottomModal({
    String subtitle =
        'The application detects permission denial, please accept the permission so that the application can run properly.',
  }) async {
    return await renderDefaultBottomModal(
      titleText: 'Access Denied',
      subtitle: subtitle,
      isExpanded: false,
      paddingContent: const EdgeInsets.all(16),
      content: [
        CustomButton(
          height: 35,
          color: Colors.red[300],
          label: 'Keep Reject',
          padding: EdgeInsets.zero,
          onTap: () => Get.back(),
        ),
        const SizedBox(height: 10),
        CustomButton(
          height: 38,
          color: Colors.teal[300],
          padding: EdgeInsets.zero,
          onTap: _themeController.isMobile ? () => openAppSettings() : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.setting, color: SharedValue.textDarkColor200),
              SizedBox(width: 10),
              Text('Go to Settings',
                  style: TextStyle(
                      color: SharedValue.textDarkColor200,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget renderSvgShadow({
    required String assetName,
    required double dx,
    required double dy,
    required double blur,
    required double opacity,
    Color? color,
  }) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: Opacity(
            opacity: opacity,
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.mode(color ?? Colors.white, BlendMode.srcATop),
              child: SvgPicture.asset(assetName),
            ),
          ),
        ),
      ),
    );
  }
}
