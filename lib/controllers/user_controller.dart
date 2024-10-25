part of 'controllers.dart';

class UserController extends GetxController {
  final DatabaseController _databaseController = Get.find();
  final ThemeController _themeController = Get.find();

  Rx<Map?> user = Rx<Map?>(null);
  Rx<List<GroupRole>> userRole = Rx<List<GroupRole>>([]);
  Rx<List> permissionUser = Rx<List>([]);

  final ApiService _apiService = ApiService();

  bool checkPermission(String permission) =>
      permissionUser.value.contains(permission);

  void updateUserRole() {
    userRole([]);

    userRole.update((_) {
      switch (user.value?['role']) {
        case 'superadmin':
          userRole.value.add(GroupRole.superAdmin);
        case 'admin':
          userRole.value.add(GroupRole.admin);
        case 'employee':
          userRole.value.add(GroupRole.employee);
        default:
          userRole.value.add(GroupRole.anonymous);
      }
    });
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool isRememberMe,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      const String url = '${SharedValue.baseUrl}/auth/login';
      Map<String, dynamic> body = {'email': email, 'password': password};

      var response = await _apiService.postData(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      var decoded = jsonDecode(response.body);

      if (decoded['success']) {
        user(decoded['data']);
        updateUserRole();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'accessToken', 'Bearer ${decoded['data']['accessToken']}');

        debugPrint('${user.value}');
        debugPrint(prefs.getString('accessToken'));

        if (isRememberMe) {
          Map data = {
            'email': email,
            'password': password,
            'expired': DateTime.now().add(const Duration(days: 14)).toString()
          };

          prefs.setString('login', jsonEncode(data));
        }

        Get.offAllNamed(Routes.home);

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: '${decoded['message']}', isError: true);

        result = false;
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'login',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: jsonDecode(response.body));

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> register({
    required Map body,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      const String url = '${SharedValue.baseUrl}/auth/register';

      var response = await _apiService.postData(
        url: url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      var decoded = jsonDecode(response.body);

      if (decoded['success']) {
        Get.toNamed(Routes.login,
            arguments: {'email': body['email'], 'password': body['password']});
        SharedWidget.renderDefaultSnackBar(message: '${decoded['message']}');

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: '${decoded['message']}', isError: true);

        result = false;
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'register',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: jsonDecode(response.body));

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> verifyOTPCode({
    required String username,
    required String password,
    required String pin,
  }) async {
    try {
      /// Declare variable
      bool result = false;
      const String url = 'https://api.npoint.io/41e4d91ba01172e722d9';
      Map<String, dynamic> body = {'user_id': user.value?['id'], 'pin': pin};

      var response = await _apiService.getData(url: url);

      var decoded = jsonDecode(response.body);

      if (decoded['message'] == null) {
        // if (pin == '555555') {
        user(decoded['data']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'login',
            jsonEncode({
              'username': username,
              'password': password,
              'expired': DateTime.now().add(const Duration(days: 14)).toString()
            }));

        Get.offAllNamed(Routes.home);
        updateUserRole();

        result = true;
      } else {
        SharedWidget.renderDefaultSnackBar(
            message: '${decoded['message']}', isError: true);

        result = false;
      }

      /// Write log
      await _databaseController.createLog(
          isDone: true,
          title: 'verifyOTPCode',
          url: url,
          method: 'POST',
          header: response.headers,
          body: body,
          response: jsonDecode(response.body));

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }

  Future<bool> logout({bool isForceLogout = false}) async {
    try {
      /// Declare variable
      bool result = true;

      if (!isForceLogout) {
        /// API Logout here
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('login');
      prefs.setBool('debugMode', false);
      _themeController.debugMode(false);
      prefs.setBool('historyLog', true);
      _themeController.historyLog(true);

      user.update((val) => user = Rx<Map?>(null));

      Get.offAllNamed(Routes.home);
      updateUserRole();

      return result;
    } on FormatException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Format Exception', message: e.message, isError: true);
      return false;
    } on ClientException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Client Exception', message: e.message, isError: true);
      return false;
    } on TimeoutException catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry Timeout Exception',
          message:
              'Request time has expired, please check your internet again and try again. (Max. ${e.duration?.inSeconds} seconds)',
          isError: true);
      return false;
    } catch (e) {
      SharedWidget.renderDefaultSnackBar(
          title: 'Sorry', message: '$e', isError: true);
      return false;
    }
  }
}
