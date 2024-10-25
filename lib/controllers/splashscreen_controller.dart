part of 'controllers.dart';

class _AutoLoginResult {
  final String route;

  _AutoLoginResult({required this.route});
}

class SplashScreenController extends GetxController {
  final UserController _userController = Get.find();
  final ThemeController _themeController = Get.find();

  late final SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    initialization();
  }

  void initialization() async {
    prefs = await SharedPreferences.getInstance();

    List response = await Future.wait([
      _autoLogin(),
      Future.delayed(const Duration(seconds: 4)),
      _themeController.initialization(),
    ]);

    _AutoLoginResult? result = response[0];
    if (result != null) {
      _userController.updateUserRole();
      Get.offAllNamed(result.route);
    }
  }

  Future<_AutoLoginResult?> _autoLogin() async {
    await Future.delayed(const Duration(seconds: 4));
    String? loginInString = prefs.getString('login');

    _themeController.initialization();

    if (loginInString != null) {
      Map login = jsonDecode(loginInString);

      if (login['expired'] != null) {
        if (DateTime.now().isAfter(DateTime.parse(login['expired']))) {
          prefs.remove('login');

          SharedWidget.renderDefaultSnackBar(
              title: 'Please Re-login',
              message: 'Your login has expired',
              isError: true);

          return _AutoLoginResult(route: Routes.login);
        } else {
          bool result = await _userController.login(
            email: login['email'],
            password: login['password'],
            isRememberMe: true,
          );

          if (result) {
            _themeController.debugMode(prefs.getBool('debugMode') ?? false);
            _themeController.setHistoryLog(prefs.getBool('historyLog') ?? true);

            return null;
          } else {
            prefs.setBool('debugMode', false);
            _themeController.debugMode(false);
            prefs.setBool('historyLog', true);
            _themeController.historyLog(true);
            prefs.remove('login');

            return _AutoLoginResult(route: Routes.login);
          }
        }
      } else {
        prefs.remove('login');
        SharedWidget.renderDefaultSnackBar(
            title: 'Please Re-login',
            message: 'Your login is experiencing some problems',
            isError: true);

        return _AutoLoginResult(route: Routes.login);
      }
    } else {
      prefs.setBool('debugMode', false);
      _themeController.debugMode(false);
      prefs.setBool('historyLog', true);
      _themeController.historyLog(true);

      return _AutoLoginResult(route: Routes.login);
    }
  }
}
