import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../models/custom_item_menu.dart';
import '../../../extensions/extensions.dart';
import '../../../controllers/controllers.dart';
import '../../../models/custom_item_dropdown.dart';
import '../../../routes/routes.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../menu_product/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();
  final ThemeController _themeController = Get.find();
  final UserController _userController = Get.find();
  final CartController _cartController = Get.find();

  final RefreshController _refreshController = RefreshController();

  final Rx<bool> _isEmployee = Rx<bool>(false);
  late final Rx<String> _selectedFilterWellness =
      Rx<String>(_menusDropdown.first.id);

  final List<CustomItemDropdown> _menusDropdown = [
    CustomItemDropdown(
      id: 'Popular',
      label: 'Terpopuler',
      icon: IconlyLight.profile,
    ),
    CustomItemDropdown(
      id: 'AtoZ',
      label: 'A to Z',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'ZtoA',
      label: 'Z to A',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'lowestPrice',
      label: 'Harga Terendah',
      icon: IconlyLight.logout,
    ),
    CustomItemDropdown(
      id: 'highestPrice',
      label: 'Harga Tertinggi',
      icon: IconlyLight.logout,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_homeController.dashboardProduct.isRxNull) {
      _homeController.getDashboardProduct();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void onRefresh() {
    Future.wait([
      _homeController.getDashboardProduct(),
    ]).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeController.primaryColor200.value,
      appBar: CustomAppBarWidget(
        backgroundColor: _themeController.primaryColor200.value,
        canReturn: false,
        titleText:
            'Selamat ${SharedMethod.getGreetings()}, ${_userController.user.value?['name']}!',
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
        centerTitle: false,
        actions: [
          const SizedBox(width: 8),
          Obx(
            () => CustomAppBarWidget.renderAppbarButton(
              icon: Iconsax.shopping_cart5,
              badge: SharedMethod.valuePrettier(
                  _cartController.selectedProducts.value.length),
              iconColor: Colors.white,
              buttonColor: Colors.white.withOpacity(.2),
              onTap: () => Get.toNamed(Routes.cart),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => CustomAppBarWidget.renderCircleAvatar(
                iconColor: Colors.white,
                buttonColor: Colors.white.withOpacity(.2),
              )),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          controller: _refreshController,
          header: MaterialClassicHeader(
              backgroundColor: _themeController.primaryColor200.value,
              color: Colors.white),
          onRefresh: onRefresh,
          child: renderBody(),
        ),
      ),
    );
  }

  Widget renderBody() {
    Widget renderTitle({
      required String title,
      Widget? child,
    }) {
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          if (child != null) child,
        ],
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: SharedValue.defaultPadding),
        padding:
            const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding)
                .copyWith(bottom: 90),
        constraints: BoxConstraints(minHeight: Get.height),
        decoration: BoxDecoration(
          color: _themeController.getPrimaryBackgroundColor.value,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_themeController.getThemeBorderRadius(20)),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: SharedValue.defaultPadding),
            CustomSlidingSegmentedControl<bool>(
              height: 33,
              fromMax: true,
              isStretch: true,
              initialValue: _isEmployee.value,
              innerPadding: const EdgeInsets.all(4),
              children: {
                false: AnimatedDefaultTextStyle(
                  maxLines: 1,
                  duration: const Duration(milliseconds: 200),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _isEmployee.value == false
                          ? Colors.white
                          : _themeController.getPrimaryTextColor.value,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: _isEmployee.value == false ? 13 : 12),
                  child: const Text('Semua Menu'),
                ),
                true: AnimatedDefaultTextStyle(
                  maxLines: 1,
                  duration: const Duration(milliseconds: 200),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _isEmployee.value == true
                          ? Colors.white
                          : _themeController.getPrimaryTextColor.value,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: _isEmployee.value == true ? 13 : 12),
                  child: const Text('Menu Karyawan'),
                ),
              },
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(20)),
                color: _themeController.getSecondaryBackgroundColor.value,
                boxShadow: _themeController.getShadowProfile(mode: 2),
              ),
              thumbDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _themeController.primaryColor200.value,
              ),
              onValueChanged: (value) => _isEmployee(value),
            ),
            const SizedBox(height: SharedValue.defaultPadding),
            renderTitle(title: 'Menu Utama'),
            const SizedBox(height: SharedValue.defaultPadding),
            CustomMasonryWidget(
              mainAxisCount: 2,
              crossAxisCount: CustomResponsiveWidget.value(context,
                  whenMobile: 4, whenTablet: 5, whenDesktop: 6),
              itemMenus: [
                CustomItemMenu(
                  name: 'People\nManagement',
                  badge: 'NEW',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-users.svg',
                ),
                CustomItemMenu(
                  name: 'Buy House',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-mosque.svg',
                ),
                CustomItemMenu(
                  name: 'My Financial',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-bank.svg',
                ),
                CustomItemMenu(
                  name: 'My Car',
                  iconSize: 40,
                  svgAsset: 'assets/icons/svg_asset-car.svg',
                ),
                CustomItemMenu(
                  name: 'My Asurance',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-building.svg',
                ),
                CustomItemMenu(
                  name: 'My Hobby',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-beach.svg',
                ),
                CustomItemMenu(
                  name: 'All\nMerchandise',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-shirt.svg',
                ),
                CustomItemMenu(
                  name: 'Gaya Hidup\nSehat',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-heart.svg',
                ),
                CustomItemMenu(
                  name: 'Konseling &\nRohani',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-chat.svg',
                ),
                CustomItemMenu(
                  name: 'Self\nDevelopment',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-brain.svg',
                ),
                CustomItemMenu(
                  name: 'Perencanaan\nKeuangan',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-card.svg',
                ),
                CustomItemMenu(
                  name: 'Konsultasi\nMedis',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-mask.svg',
                ),
                CustomItemMenu(
                  name: 'Kuliner',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-food.svg',
                ),
                CustomItemMenu(
                  name: 'Kebutuhan\nHarian',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-shop.svg',
                ),
                CustomItemMenu(
                  name: 'Pulsa dan Listrik',
                  iconSize: 35,
                  svgAsset: 'assets/icons/svg_asset-electrical.svg',
                ),
                CustomItemMenu(
                  name: 'Donasi',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-donate.svg',
                ),
                CustomItemMenu(
                  name: 'Perangkat Kerja',
                  iconSize: 30,
                  svgAsset: 'assets/icons/svg_asset-work.svg',
                ),
              ],
            ),
            const SizedBox(height: SharedValue.defaultPadding * 2),
            renderTitle(
              title: 'Latest Products',
              child: CustomDropdownWidget<String>(
                buttonHeight: 25,
                value: _selectedFilterWellness.value,
                onChanged: (value) => _selectedFilterWellness(value),
                buttonDecoration: BoxDecoration(
                  border: const Border(),
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(30),
                  ),
                ),
                items: List.generate(
                  _menusDropdown.length,
                  (i) => DropdownMenuItem<String>(
                    value: _menusDropdown[i].id,
                    child: Text(
                      _menusDropdown[i].label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _themeController.getPrimaryTextColor.value),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: SharedValue.defaultPadding),
            Obx(
              () {
                int length =
                    _homeController.dashboardProduct.value?.length ?? 0;

                return _homeController.dashboardProduct.isRxNull
                    ? WaitingWidget()
                    : _homeController.dashboardProduct.value?.isEmpty ?? true
                        ? const EmptyWidget()
                        : GridView.builder(
                            itemCount: length < 5 ? length : 5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 145,
                              mainAxisSpacing: SharedValue.defaultPadding,
                              crossAxisSpacing: SharedValue.defaultPadding,
                              crossAxisCount: CustomResponsiveWidget.value(
                                  context,
                                  whenMobile: 2,
                                  whenTablet: 3,
                                  whenDesktop: 4),
                            ),
                            itemBuilder: (context, index) => renderCard(index),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget renderCard(int index) {
    var data = _homeController.dashboardProduct.value?[index];

    return InkWell(
      onTap: () async => await Get.to(() => const ProductDetailPage(),
          arguments: '${data['id']}'),
      highlightColor: _themeController.primaryColor200.value.withOpacity(.1),
      splashColor: _themeController.primaryColor200.value.withOpacity(.2),
      child: CustomCardWidget(
        padding: EdgeInsets.zero,
        child: PaddingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.all(SharedValue.defaultPadding / 2),
          children: [
            Container(
              height: 80,
              width: Get.width,
              decoration: BoxDecoration(
                color: _themeController.primaryColor200.value.withOpacity(.2),
                borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(10),
                ),
              ),
              child: Icon(Iconsax.box,
                  size: 50, color: _themeController.primaryColor200.value),
            ),
            const Spacer(),
            Text(
              SharedMethod.valuePrettier(data['name']),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              SharedMethod.formatValueToCurrency(20000),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _themeController.getSecondaryTextColor.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
