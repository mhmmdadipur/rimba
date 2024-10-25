import 'package:get/get.dart';

import '../ui/pages/menu_cart/cart_page.dart';
import '../ui/pages/menu_home/home_page.dart';
import '../ui/pages/menu_account/login_page.dart';
import '../ui/pages/main_page.dart';
import '../ui/pages/maintenance_page.dart';
import '../ui/pages/menu_account/account_page.dart';
import '../ui/pages/menu_account/change_password_page.dart';
import '../ui/pages/menu_logs/logs_detail_page.dart';
import '../ui/pages/menu_logs/logs_page.dart';
import '../ui/pages/menu_product/product_page.dart';
import '../ui/pages/menu_transaction/transaction_page.dart';
import '../ui/pages/splash_screen.dart';

import 'middleware.dart';

class Routes {
  ///! Generic Routes
  static String splashScreen = '/';
  static String login = '/login';
  static String register = '/register';
  static String maintenance = '/404';

  ///! Account Routes
  static String myAccount = '/my-account';
  static String changePassword = '/change-password';

  ///! Service Routes
  static String logs = '/logs';

  ///! Pages
  static String home = '/home';
  static String homeMaintenance = '$home/$maintenance';
  static String product = '/product';
  static String cart = '/cart';
  static String transaction = '/transaction';

  static List<GetPage<dynamic>>? pages = [
    ///! Generic Routes
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: login,
      middlewares: [LoginMiddleware()],
      page: () => const LoginPage(child: LoginFormSection()),
    ),
    GetPage(
      name: register,
      middlewares: [LoginMiddleware()],
      page: () => const LoginPage(child: RegisterFormSection()),
    ),
    GetPage(
      name: maintenance,
      page: () => const MaintenancePage(),
    ),

    ///! Account Routes
    GetPage(
      name: myAccount,
      middlewares: [AuthMiddleware()],
      page: () => const AccountPage(),
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePasswordPage(),
    ),

    ///! Service Routes
    GetPage(
      name: logs,
      middlewares: [AuthMiddleware(), DebugMiddleware()],
      page: () => const LogsPage(),
    ),
    GetPage(
      name: '$logs/:id',
      middlewares: [AuthMiddleware(), DebugMiddleware()],
      page: () => const LogsDetailPage(),
    ),

    ///! Pages
    GetPage(
      name: homeMaintenance,
      middlewares: [AuthMiddleware()],
      page: () => const MainPage(child: MaintenancePage(showBackButton: false)),
    ),
    GetPage(
      name: home,
      middlewares: [AuthMiddleware()],
      page: () => const MainPage(child: HomePage()),
    ),
    GetPage(
      name: product,
      middlewares: [AuthMiddleware()],
      page: () => const MainPage(child: ProductPage()),
    ),
    GetPage(
      name: cart,
      middlewares: [AuthMiddleware()],
      page: () => const CartPage(),
    ),
    GetPage(
      name: transaction,
      middlewares: [AuthMiddleware()],
      page: () => const MainPage(child: TransactionPage()),
    ),
  ];
}
