part of 'controllers.dart';

class ThemeController extends GetxController {
  late SharedPreferences _sharedPreferences;

  Rx<int> selectedTheme = Rx<int>(0);
  Rx<ThemeMode> selectedThemeMode = Rx<ThemeMode>(ThemeMode.light);

  Rx<int> blendLevel = Rx<int>(1); //! Deprecated
  Rx<double> borderRadius = Rx<double>(50);
  Rx<SnackPosition> snackPosition = Rx<SnackPosition>(SnackPosition.TOP);

  Rx<bool> expandMode = Rx<bool>(false); //! Deprecated
  Rx<bool> debugMode = Rx<bool>(false);
  Rx<bool> m3Mode = Rx<bool>(true); //! Deprecated
  Rx<bool> historyLog = Rx<bool>(true);
  Rx<bool> showButtonLog = Rx<bool>(true); //! Deprecated

  Rx<Color> primaryColor100 = Rx<Color>(const Color(0xff74b4e2));
  Rx<Color> primaryColor200 = Rx<Color>(const Color(0xff1772b8));
  Rx<Color> primaryColor300 = Rx<Color>(const Color(0xff005ea2));
  Rx<Color> secondaryColor100 = Rx<Color>(const Color(0xffFFC000));
  Rx<Color> secondaryColor200 = Rx<Color>(const Color(0xffB38600));

  Rx<String?> appName = Rx<String?>(null);
  Rx<String?> packageName = Rx<String?>(null);
  Rx<String?> version = Rx<String?>(null);
  Rx<String?> buildNumber = Rx<String?>(null);

  List<CustomDataTheme> themeDataList = [
    CustomDataTheme(
        name: 'Blue',
        primaryColor100: const Color(0xff5deff7),
        primaryColor200: const Color(0xff25cad2),
        primaryColor300: const Color(0xff00a6ae),
        secondaryColor100: const Color(0xff0074c8),
        secondaryColor200: const Color(0xff0060b1)),
    CustomDataTheme(
        name: 'Orange',
        primaryColor100: const Color(0xffffea45),
        primaryColor200: const Color(0xfff8c20a),
        primaryColor300: const Color(0xffcc9c00),
        secondaryColor100: const Color(0xff092C4C),
        secondaryColor200: const Color(0xff002645)),
    CustomDataTheme(
        name: 'Purple',
        primaryColor100: const Color(0xff8e7eff),
        primaryColor200: const Color(0xff7367F0),
        primaryColor300: const Color(0xff5751d6),
        secondaryColor100: const Color(0xffb5c33a),
        secondaryColor200: const Color(0xff8f9f0a)),
    CustomDataTheme(
        name: 'Green',
        primaryColor100: const Color(0xff65c071),
        primaryColor200: const Color(0xff47a357),
        primaryColor300: const Color(0xff27873d),
        secondaryColor100: const Color(0xffa34793),
        secondaryColor200: const Color(0xff8d327f)),
  ];

  @override
  void onInit() {
    super.onInit();
    initialization();
  }

  Future<void> initialization() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName(packageInfo.appName);
    packageName(packageInfo.packageName);
    version(packageInfo.version);
    buildNumber(packageInfo.buildNumber);
  }

  bool get isMobile =>
      (!kIsWeb && Platform.isIOS) || (!kIsWeb && Platform.isAndroid);

  bool get isDesktop =>
      (!kIsWeb && Platform.isLinux) ||
      (!kIsWeb && Platform.isWindows) ||
      (!kIsWeb && Platform.isMacOS);

  bool get isWeb => kIsWeb;

  Rx<bool> get isDarkMode => (selectedThemeMode.value == ThemeMode.dark).obs;

  WidgetStateProperty<Color> get getMaterialStateColor =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey;
        } else if (states.contains(WidgetState.selected)) {
          return isDarkMode.value
              ? primaryColor100.value
              : primaryColor200.value;
        }
        return isDarkMode.value ? Colors.white : Colors.black;
      });

  Rx<Color> get getPrimaryBackgroundColor => (isDarkMode.value
          ? SharedValue.backgroundDarkColor200
          : SharedValue.backgroundLightColor200)
      .obs;

  Rx<Color> get getSecondaryBackgroundColor => (isDarkMode.value
          ? SharedValue.backgroundDarkColor100
          : SharedValue.backgroundLightColor100)
      .obs;

  Rx<Color> get getPrimaryTextColor => (isDarkMode.value
          ? SharedValue.textDarkColor200
          : SharedValue.textLightColor200)
      .obs;

  Rx<Color> get getSecondaryTextColor => (isDarkMode.value
          ? SharedValue.textDarkColor100
          : SharedValue.textLightColor100)
      .obs;

  DateRangePickerHeaderStyle get getDatePickerHeaderStyle =>
      DateRangePickerHeaderStyle(
          backgroundColor: Colors.transparent,
          textStyle: TextStyle(color: getPrimaryTextColor.value));

  DateRangePickerYearCellStyle get getDatePickerYearCellStyle =>
      DateRangePickerYearCellStyle(
          textStyle: TextStyle(color: getPrimaryTextColor.value),
          disabledDatesTextStyle: const TextStyle(color: Colors.grey));

  DateRangePickerMonthViewSettings get getDatePickerMonthViewStyle =>
      DateRangePickerMonthViewSettings(
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
              backgroundColor: Colors.transparent,
              textStyle: TextStyle(
                  color: getPrimaryTextColor.value,
                  fontWeight: FontWeight.w500)));

  DateRangePickerMonthCellStyle get getDatePickerMonthCellStyle =>
      DateRangePickerMonthCellStyle(
          textStyle: TextStyle(color: getPrimaryTextColor.value),
          disabledDatesTextStyle: const TextStyle(color: Colors.grey));

  Future<void> setTheme(int index) async {
    if (index >= themeDataList.length) index = 0;

    selectedTheme(index);
    primaryColor100(themeDataList[index].primaryColor100);
    primaryColor200(themeDataList[index].primaryColor200);
    primaryColor300(themeDataList[index].primaryColor300);
    secondaryColor100(themeDataList[index].secondaryColor100);
    secondaryColor200(themeDataList[index].secondaryColor200);

    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setInt('theme', index);
    });
  }

  Future<void> setThemeMode(bool darkThemeOn) async {
    selectedThemeMode(darkThemeOn ? ThemeMode.dark : ThemeMode.light);
    setStatusBarMode();
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('darkTheme', darkThemeOn);
    });
  }

  Future<void> setStatusBarMode({Color? systemNavigationBarColor}) async {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            systemNavigationBarColor ?? getSecondaryBackgroundColor.value,
        statusBarIconBrightness:
            isDarkMode.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkMode.value ? Brightness.light : Brightness.dark));
  }

  Future<void> setThemeBorderRadius(double value) async {
    borderRadius(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setDouble('borderRadius', value);
    });
  }

  Future<void> setThemeBlendLevel(int value) async {
    blendLevel(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setInt('blendLevel', value);
    });
  }

  Future<void> setExpandMode(bool value) async {
    expandMode(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('expandMode', value);
    });
  }

  Future<void> setM3Mode(bool value) async {
    m3Mode(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('m3Mode', value);
    });
  }

  Future<void> setHistoryLog(bool value) async {
    historyLog(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('historyLog', value);
    });
  }

  Future<void> setShowButtonLog(bool value) async {
    showButtonLog(value);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('showButtonLog', value);
    });
  }

  Future<void> setSnackPosition(bool isMessageAtTop) async {
    snackPosition(isMessageAtTop ? SnackPosition.TOP : SnackPosition.BOTTOM);
    SharedPreferences.getInstance().then((sharedPreferences) async {
      _sharedPreferences = sharedPreferences;
      await _sharedPreferences.setBool('isMessageAtTop', isMessageAtTop);
    });
  }

  double getThemeBorderRadius(double value) {
    double result = value * (borderRadius.value * 2) / 100;
    if (result < 0) return 0;
    return result;
  }

  Color getBlendColor(BuildContext context,
      {int alphaDark = 16, int alphaLight = 22}) {
    return Color.alphaBlend(
        Theme.of(context)
            .colorScheme
            .primary
            .withAlpha(isDarkMode.value ? alphaDark : alphaLight),
        Theme.of(context).cardColor);
  }

  Future<void> setDebugMode(bool value) async {
    String passwordInserted = '';

    if (value) {
      var response = await SharedWidget.renderDefaultDialog(
        icon: Icons.code_rounded,
        title: 'Debug Mode',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Debug mode requires a password to be provided, this was created to prevent misuse',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: "Password",
              obscureText: true,
              keyboardType: TextInputType.text,
              onChanged: (value) => passwordInserted = value,
              onSubmitted: (value) =>
                  Get.back(result: value == SharedValue.passDebugMode),
              decoration: BoxDecoration(
                  color: getPrimaryBackgroundColor.value,
                  borderRadius: BorderRadius.circular(20)),
              prefixIcon: const Icon(IconlyBroken.setting),
            ),
          ],
        ),
        onSubmit: () =>
            Get.back(result: passwordInserted == SharedValue.passDebugMode),
      );
      if (response != null && response) {
        debugMode(value);
        SharedPreferences.getInstance().then((sharedPreferences) {
          _sharedPreferences = sharedPreferences;
          _sharedPreferences.setBool('debugMode', value);
        });
      }
    } else {
      debugMode(value);
      SharedPreferences.getInstance().then((sharedPreferences) {
        _sharedPreferences = sharedPreferences;
        _sharedPreferences.setBool('debugMode', value);
      });
    }
  }

  List<BoxShadow> getShadowProfile(
      {int mode = 1, Color color = Colors.black, bool reversed = false}) {
    assert(mode >= 1 && mode <= 2);
    switch (mode) {
      case 1:
        return [
          SharedMethod.renderBoxShadow(
              dy: 27 * (reversed ? -1 : 1),
              blurRadius: 80,
              opacity: .0700,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 11.28 * (reversed ? -1 : 1),
              blurRadius: 33.42,
              opacity: .0503,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 6.03 * (reversed ? -1 : 1),
              blurRadius: 17.87,
              opacity: .0417,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 3.38 * (reversed ? -1 : 1),
              blurRadius: 10.02,
              opacity: .0350,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 1.8 * (reversed ? -1 : 1),
              blurRadius: 5.32,
              opacity: .0283,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 0.75 * (reversed ? -1 : 1),
              blurRadius: 2.21,
              opacity: .0197,
              color: color),
        ];
      case 2:
        return [
          SharedMethod.renderBoxShadow(
              dy: 12.52 * (reversed ? -1 : 1),
              blurRadius: 10.02,
              opacity: .0350,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 6.65 * (reversed ? -1 : 1),
              blurRadius: 5.32,
              opacity: .0283,
              color: color),
          SharedMethod.renderBoxShadow(
              dy: 2.77 * (reversed ? -1 : 1),
              blurRadius: 2.21,
              opacity: .0197,
              color: color),
        ];
      default:
        return [];
    }
  }
}
