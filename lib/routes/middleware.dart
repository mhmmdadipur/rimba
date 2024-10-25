import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../extensions/extensions.dart';
import '../controllers/controllers.dart';
import 'routes.dart';

class LoginMiddleware extends GetMiddleware {
  final UserController _userController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (_userController.user.isNotRxNull) {
      return RouteSettings(name: Routes.home);
    } else {
      return null;
    }
  }
}

class AuthMiddleware extends GetMiddleware {
  final UserController _userController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (_userController.user.isRxNull) {
      return RouteSettings(name: Routes.login);
    } else {
      return null;
    }
  }
}

class DebugMiddleware extends GetMiddleware {
  final UserController _userController = Get.find();
  final ThemeController _themeController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (_userController.user.isNotRxNull && _themeController.debugMode.value) {
      return null;
    } else {
      return RouteSettings(name: Routes.home);
    }
  }
}
