import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/controllers.dart';
import 'extensions/extensions.dart';
import 'routes/routes.dart';
import 'shared/shared.dart';
import 'ui/pages/maintenance_page.dart';
import 'ui/widgets/custom_floating_draggable_widget.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if ((!kIsWeb && Platform.isIOS) || (!kIsWeb && Platform.isAndroid)) {
    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  }

  final ThemeController themeController =
      Get.put(ThemeController(), permanent: true);

  SharedPreferences.getInstance().then(
    (sharedPreferences) {
      ///take index data from shared preferences,
      ///then check whether the data is valid or not by adjusting the length of
      ///the theme data
      int indexTheme = sharedPreferences.getInt('theme') ?? 0;
      if (indexTheme >= themeController.themeDataList.length) indexTheme = 0;

      themeController.setTheme(indexTheme);
      themeController
          .setThemeMode(sharedPreferences.getBool('darkTheme') ?? false);
      themeController
          .setExpandMode(sharedPreferences.getBool('expandMode') ?? false);
      themeController.setM3Mode(sharedPreferences.getBool('m3Mode') ?? true);
      themeController
          .borderRadius(sharedPreferences.getDouble('borderRadius') ?? 50);
      themeController.blendLevel(sharedPreferences.getInt('blendLevel') ?? 1);
      themeController.setSnackPosition(
          sharedPreferences.getBool('isMessageAtTop') ?? true);
      themeController
          .setShowButtonLog(sharedPreferences.getBool('showButtonLog') ?? true);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((value) => runApp(const MyApp()));
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseController logsController = Get.put(DatabaseController());
  final UserController userController = Get.put(UserController());
  final MainController mainController = Get.put(MainController());
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());
  final TransactionController transactionController =
      Get.put(TransactionController());

  final ThemeController _themeController = Get.find();

  late StreamSubscription streamConnectivity;

  @override
  void initState() {
    super.initState();
    streamConnectivity =
        Connectivity().onConnectivityChanged.listen((status) async {
      if (status.first == ConnectivityResult.none) {
        SharedWidget.renderDefaultSnackBar(
            title: 'Koneksi Internet Terputus',
            message: 'Mohon periksa ulang koneksi internet anda.',
            icon: EvaIcons.wifiOffOutline,
            duration: null,
            isError: true);
      } else {
        Get.closeCurrentSnackbar();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        _themeController.setStatusBarMode();
        return GetMaterialApp(
          title: SharedValue.appName,
          debugShowCheckedModeBanner: false,
          themeMode: _themeController.selectedThemeMode.value,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.light,
            hoverColor: Colors.transparent,
            scaffoldBackgroundColor: SharedValue.backgroundLightColor200,
            dividerColor:
                _themeController.getPrimaryTextColor.value.withOpacity(.1),
            primaryColor: _themeController.primaryColor200.value,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.light,
              primary: _themeController.primaryColor200.value,
              primaryContainer: const Color(0xff311b92),
              secondary: _themeController.secondaryColor100.value,
              secondaryContainer: const Color(0xffFED049),
              tertiary: const Color(0xff432C7A),
              tertiaryContainer: const Color(0xff80489C),
              error: SharedValue.errorColor,
              surface: _themeController.getPrimaryBackgroundColor.value,
            ),
            appBarTheme: const AppBarTheme(
              color: SharedValue.textDarkColor200,
              surfaceTintColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              centerTitle: false,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Poppins',
            brightness: Brightness.dark,
            hoverColor: Colors.transparent,
            scaffoldBackgroundColor: SharedValue.backgroundDarkColor200,
            dividerColor:
                _themeController.getPrimaryTextColor.value.withOpacity(.1),
            primaryColor: _themeController.primaryColor200.value,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.dark,
              primary: _themeController.primaryColor200.value,
              primaryContainer: const Color(0xff311b92),
              secondary: _themeController.secondaryColor100.value,
              secondaryContainer: const Color(0xffFED049),
              tertiary: const Color(0xff432C7A),
              tertiaryContainer: const Color(0xff80489C),
              error: SharedValue.errorColor,
              surface: _themeController.getPrimaryBackgroundColor.value,
            ),
            appBarTheme: const AppBarTheme(
              color: SharedValue.backgroundDarkColor200,
              surfaceTintColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              centerTitle: false,
              titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .5),
            ),
          ),
          builder: (context, child) => Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) => renderBuilder(child)),
            ],
          ),
          defaultTransition: Transition.noTransition,
          initialRoute: Routes.splashScreen,
          getPages: Routes.pages,
          unknownRoute: GetPage(
            name: Routes.maintenance,
            page: () => const MaintenancePage(),
          ),
        );
      },
    );
  }

  Widget renderBuilder(Widget? child) {
    double size = 40;

    Rx<bool> onDragging = Rx<bool>(false);
    Rx<FloatingDraggableAlignPosition> alignPosition =
        Rx<FloatingDraggableAlignPosition>(
            FloatingDraggableAlignPosition.right);

    return Obx(
      () => Scaffold(
        key: mainController.globalScaffoldKey,
        drawerScrimColor: Colors.transparent,
        endDrawer: const CustomDrawerSettingWidget(),
        body: FloatingDraggableWidget(
          autoAlign: true,
          floatingWidgetWidth: size,
          floatingWidgetHeight: size,
          resizeToAvoidBottomInset: false,
          onDragging: (p0) => onDragging(p0),
          alignPosition: (value) => alignPosition(value),
          floatingDraggableAlign: FloatingDraggableAutoAlign.both,
          screenWidth: MediaQuery.of(context).size.width,
          screenHeight: MediaQuery.of(context).size.height,
          dx: MediaQuery.of(context).size.width - size,
          dy: MediaQuery.of(context).size.height / 2 - size,
          mainScreenWidget: child ?? const MaintenancePage(),
          floatingWidget: Visibility(
            visible: userController.user.isNotRxNull,
            child: FloatingActionButton(
              backgroundColor: _themeController.primaryColor200.value,
              shape: RoundedRectangleBorder(
                borderRadius: onDragging.value
                    ? BorderRadius.circular(10)
                    : BorderRadius.only(
                        topRight: Radius.circular([
                          FloatingDraggableAlignPosition.bottom,
                          FloatingDraggableAlignPosition.left,
                          FloatingDraggableAlignPosition.center,
                        ].contains(alignPosition.value)
                            ? 10
                            : 0),
                        topLeft: Radius.circular([
                          FloatingDraggableAlignPosition.bottom,
                          FloatingDraggableAlignPosition.right,
                          FloatingDraggableAlignPosition.center,
                        ].contains(alignPosition.value)
                            ? 10
                            : 0),
                        bottomLeft: Radius.circular([
                          FloatingDraggableAlignPosition.top,
                          FloatingDraggableAlignPosition.right,
                          FloatingDraggableAlignPosition.center,
                        ].contains(alignPosition.value)
                            ? 10
                            : 0),
                        bottomRight: Radius.circular([
                          FloatingDraggableAlignPosition.top,
                          FloatingDraggableAlignPosition.left,
                          FloatingDraggableAlignPosition.center,
                        ].contains(alignPosition.value)
                            ? 10
                            : 0),
                      ),
              ),
              child: const Icon(IconlyBroken.setting),
              onPressed: () async {
                mainController.globalScaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ),
      ),
    );
  }
}
