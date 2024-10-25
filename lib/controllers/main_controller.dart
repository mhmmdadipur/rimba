part of 'controllers.dart';

class MainController extends GetxController {
  Rx<bool> isLoading = Rx<bool>(false);
  Rx<String> selectedItemNavbarId = Rx<String>('home');

  final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey();

  List<CustomItemNavbar> navbarMenu = [
    CustomItemNavbar(
      id: 'home',
      label: 'Home',
      slug: Routes.home,
      selectedIcon: IconlyLight.home,
      unselectedIcon: IconlyLight.home,
    ),
    CustomItemNavbar(
      id: 'product',
      label: 'Product',
      slug: Routes.product,
      selectedIcon: Iconsax.box,
      unselectedIcon: Iconsax.box,
    ),
    CustomItemNavbar(
      id: 'transaction',
      label: 'Transaction',
      slug: Routes.transaction,
      selectedIcon: Iconsax.empty_wallet_change,
      unselectedIcon: Iconsax.empty_wallet_change,
    ),
    CustomItemNavbar(
      id: 'analysis',
      label: 'Analysis',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.presention_chart,
      unselectedIcon: Iconsax.presention_chart,
    ),
    CustomItemNavbar(
      id: 'academy',
      label: 'Academy',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.book,
      unselectedIcon: Iconsax.book,
    ),
    CustomItemNavbar(
      id: 'voucher',
      label: 'Voucher',
      slug: Routes.homeMaintenance,
      selectedIcon: Iconsax.receipt_2,
      unselectedIcon: Iconsax.receipt_2,
    ),
    CustomItemNavbar(
      id: 'friends',
      label: 'Daftar Teman',
      slug: Routes.homeMaintenance,
      selectedIcon: IconlyLight.user_1,
      unselectedIcon: IconlyLight.user_1,
    ),
  ];
}
