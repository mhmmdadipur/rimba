part of 'widgets.dart';

class WaitingWidget extends StatelessWidget {
  WaitingWidget({
    super.key,
    this.loadingIndicatorColor,
    this.titleTextColor,
    this.subtitleTextColor,
  });

  final ThemeController _themeController = Get.find();
  final List<Color>? loadingIndicatorColor;
  final Color? titleTextColor;
  final Color? subtitleTextColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.height * .15,
            height: Get.height * .15,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse,
              colors: loadingIndicatorColor ??
                  [
                    _themeController.primaryColor200.value,
                    _themeController.primaryColor100.value,
                  ],
            ),
          ),
          Text(
            'Loading...',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: titleTextColor ??
                    _themeController.getPrimaryTextColor.value),
          ),
          Text(
            'Loading data.',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: subtitleTextColor ??
                    _themeController.getPrimaryTextColor.value),
          ),
        ],
      ),
    );
  }
}

class SimpleWaitingWidget extends StatelessWidget {
  SimpleWaitingWidget({
    super.key,
    this.loadingIndicatorColor,
    this.titleTextColor,
    this.subtitleTextColor,
  });

  final ThemeController _themeController = Get.find();
  final List<Color>? loadingIndicatorColor;
  final Color? titleTextColor;
  final Color? subtitleTextColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.height * .10,
            height: Get.height * .10,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse,
              colors: loadingIndicatorColor ??
                  [
                    _themeController.primaryColor200.value,
                    _themeController.primaryColor100.value,
                  ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: titleTextColor ??
                          _themeController.getPrimaryTextColor.value),
                ),
                Text(
                  'Loading data.',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: subtitleTextColor ??
                          _themeController.getPrimaryTextColor.value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.gap = 0,
  });

  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/png_asset-not_found.png',
                height: Get.height * .3),
          ),
          SizedBox(height: gap),
          Text(
            title ?? 'No Data :(',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                .copyWithTextStyle(titleStyle),
          ),
          Text(
            subtitle ?? 'Oops! 😖 data not found.\nPull to refresh data.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500)
                .copyWithTextStyle(subtitleStyle),
          ),
        ],
      ),
    );
  }
}

class SimpleEmptyWidget extends StatelessWidget {
  final String? message;

  const SimpleEmptyWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie.asset(
          //   'assets/animations/empty-box.json',
          //   width: Get.height * .13,
          //   height: Get.height * .13,
          // ),
          Center(
            child: Image.asset('assets/images/png_asset-not_found.png',
                width: Get.height * .13, height: Get.height * .13),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No Data :(',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  message ?? 'Oops! 😖 data not found.\nPull to refresh data.',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
