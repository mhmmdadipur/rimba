import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../models/custom_status.dart';
import '../../../routes/routes.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'product_edit_page.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ThemeController _themeController = Get.find();
  final ProductController _productController = Get.find();
  final CartController _cartController = Get.find();
  final UserController _userController = Get.find();

  final RefreshController _refreshController = RefreshController();

  final Rx<bool> _isLoading = Rx<bool>(false);

  @override
  void initState() {
    super.initState();

    _productController.getDetailProduct(idProduct: '${Get.arguments}');
  }

  @override
  void dispose() {
    _productController.detailProduct = Rx<Map?>(null);

    _refreshController.dispose();

    super.dispose();
  }

  void onRefresh() {
    FocusManager.instance.primaryFocus?.unfocus();

    Future.wait([
      _productController.getDetailProduct(idProduct: '${Get.arguments}'),
    ]).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  Future<void> onTapEditButton() async {
    var res = await Get.to(() => const ProductEditPage(),
        arguments: _productController.detailProduct.value);

    if (res != null) {
      _isLoading(true);
      await _productController.getDetailProduct(idProduct: '${Get.arguments}');
      _isLoading(false);
    }
  }

  Future<void> onTapDeleteButton() async {
    var res = await SharedWidget.renderDefaultDialog(
      icon: Iconsax.edit,
      backgroundIconColor: Colors.red.shade700,
      title: 'Are you sure?',
      contentText: 'Are you sure you want to delete this data?',
    );

    if (res != null) {
      _isLoading(true);
      await _productController.deleteProduct(idProduct: '${Get.arguments}');
      _isLoading(false);
    }
  }

  Future<void> onTapAddToCartButton() async {
    if (_productController.detailProduct.isRxNull) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Data not found', isError: true);
      return;
    }

    _isLoading(true);
    _cartController.addToCart(_productController.detailProduct.value!);
    SharedWidget.renderDefaultSnackBar(
        message: 'Add to cart success', isError: false);
    _isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: CustomAppBarWidget(
              titleText: 'Detail Product',
              actions: [
                const SizedBox(width: 8),
                Obx(
                  () => CustomAppBarWidget.renderAppbarButton(
                    icon: Iconsax.shopping_cart,
                    iconColor: _themeController.getPrimaryTextColor.value,
                    buttonColor: Colors.transparent,
                    badge: SharedMethod.valuePrettier(
                        _cartController.selectedProducts.value.length),
                    onTap: () => Get.toNamed(Routes.cart),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Obx(
                  () {
                    if (_productController.detailProduct.isRxNull) {
                      return WaitingWidget();
                    }

                    return SmartRefresher(
                      onRefresh: onRefresh,
                      controller: _refreshController,
                      header: MaterialClassicHeader(
                        color: Colors.white,
                        backgroundColor: _themeController.primaryColor200.value,
                      ),
                      child: _productController.detailProduct.value!.isEmpty
                          ? const EmptyWidget()
                          : renderContent(),
                    );
                  },
                ),
                Obx(() => renderButton()),
              ],
            ),
          ),
        ),
        Obx(() {
          return SharedWidget.renderDefaultLoading(isLoading: _isLoading.value);
        }),
      ],
    );
  }

  Widget renderButton() {
    if (_productController.detailProduct.isRxNull) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(SharedValue.defaultPadding),
      decoration: BoxDecoration(
        color: _themeController.getPrimaryBackgroundColor.value,
        border: Border(
          top: BorderSide(
            color: _themeController.getSecondaryTextColor.value.withOpacity(.3),
          ),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            _themeController.getThemeBorderRadius(20),
          ),
        ),
      ),
      child: Row(
        children: [
          Visibility(
            visible: '${_productController.detailProduct.value?['userId']}' ==
                '${_userController.user.value?['id']}',
            child: CustomButton(
              width: 35,
              height: 35,
              padding: EdgeInsets.zero,
              label: 'Edit Data',
              color: Colors.orange.shade700,
              onTap: onTapEditButton,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade700.withOpacity(.2),
                border: Border.all(color: Colors.orange.shade700),
              ),
              child:
                  Icon(Iconsax.edit, size: 20, color: Colors.orange.shade700),
            ),
          ),
          Visibility(
              visible: '${_productController.detailProduct.value?['userId']}' ==
                  '${_userController.user.value?['id']}',
              child: const SizedBox(width: SharedValue.defaultPadding)),
          Visibility(
            visible: '${_productController.detailProduct.value?['userId']}' ==
                '${_userController.user.value?['id']}',
            child: CustomButton(
              width: 35,
              height: 35,
              padding: EdgeInsets.zero,
              label: 'Delete Data',
              color: Colors.red.shade700,
              onTap: onTapDeleteButton,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade700.withOpacity(.2),
                border: Border.all(color: Colors.red.shade700),
              ),
              child: Icon(Iconsax.trash, size: 20, color: Colors.red.shade700),
            ),
          ),
          Visibility(
              visible: '${_productController.detailProduct.value?['userId']}' ==
                  '${_userController.user.value?['id']}',
              child: const SizedBox(width: SharedValue.defaultPadding)),
          Expanded(
            child: CustomButton(
              height: 35,
              padding: EdgeInsets.zero,
              label: 'Add to Cart',
              color: Colors.teal.shade700,
              onTap: onTapAddToCartButton,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              decoration: BoxDecoration(
                color: Colors.teal.shade700.withOpacity(.6),
                border: Border.all(color: Colors.teal.shade700),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.shopping_cart, size: 20, color: Colors.white),
                  SizedBox(width: SharedValue.defaultPadding / 2),
                  Flexible(
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderContent() {
    var data = _productController.detailProduct.value;
    CustomStatus status =
        _productController.generateStatusLabel('${data?['deletedAt']}');

    Widget renderDetailRow({
      required String title,
      String? subtitle,
      Widget? child,
    }) {
      assert(subtitle != null || child != null);
      assert(!(subtitle != null && child != null));

      return PaddingRow(
        padding: const EdgeInsets.only(bottom: 8),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _themeController.getSecondaryTextColor.value,
              ),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          if (subtitle != null)
            Expanded(
              flex: 1,
              child: Text(
                subtitle,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _themeController.getPrimaryTextColor.value,
                ),
              ),
            ),
          if (child != null) child,
        ],
      );
    }

    return ListView(
      padding:
          const EdgeInsets.all(SharedValue.defaultPadding).copyWith(bottom: 90),
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
        const SizedBox(height: 20),
        const Text(
          'Name Product',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 35,
          padding: const EdgeInsets.only(left: 15, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            SharedMethod.valuePrettier(data?['name']),
            style: const TextStyle(
              height: 1,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Product Price',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 35,
          padding: const EdgeInsets.only(left: 15, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            SharedMethod.formatValueToCurrency(20000, decimalDigits: 0),
            style: const TextStyle(
              height: 1,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        renderDetailRow(
          title: 'Created At',
          subtitle: SharedMethod.formatValueToDate(
            data?['createdAt'],
            replace: '-',
            convertToLocal: true,
            newPattern: 'HH:mm, dd MMMM yyyy',
          ),
        ),
        renderDetailRow(
          title: 'Updated At',
          subtitle: SharedMethod.formatValueToDate(
            data?['updatedAt'],
            replace: '-',
            convertToLocal: true,
            newPattern: 'HH:mm, dd MMMM yyyy',
          ),
        ),
        renderDetailRow(
          title: 'Deleted At',
          subtitle: SharedMethod.formatValueToDate(
            data?['deletedAt'],
            replace: '-',
            convertToLocal: true,
            newPattern: 'HH:mm, dd MMMM yyyy',
          ),
        ),
        renderDetailRow(
          title: 'Status',
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: SharedValue.defaultPadding / 2,
                vertical: SharedValue.defaultPadding / 4),
            decoration: BoxDecoration(
              color: status.colorStatus?.withOpacity(.1),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(5)),
              border: Border.all(
                width: 1.5,
                color: status.colorStatus ?? Colors.transparent,
              ),
            ),
            child: Text(
              SharedMethod.valuePrettier(status.labelStatus),
              style: TextStyle(
                fontSize: 11,
                color: status.colorStatus,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
