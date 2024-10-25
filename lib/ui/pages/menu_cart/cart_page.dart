import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import '../menu_transaction/transaction_add_page.dart';
import 'cart_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FocusNode _focusSearchField = FocusNode();

  final ThemeController _themeController = Get.find();
  final CartController _cartController = Get.find();

  final TextEditingController _searchTextController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  final Rx<bool> _isLoading = Rx<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _refreshController.dispose();
    _focusSearchField.dispose();

    super.dispose();
  }

  void onTapBuyButton() {
    debugPrint('${_cartController.selectedProducts.value}');
    if (_cartController.selectedProducts.value.isEmpty) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Please select product', isError: true);
      return;
    }

    Get.to(() => const TransactionAddPage());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBarWidget(
              titleText: 'My Cart',
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Obx(() => renderContent()),
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
    int total = 0;
    total = _cartController.selectedProducts.value.fold(0, (sum, item) {
      int qty = item['quantity'] as int;
      return sum + (qty * 20000);
    });

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
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _themeController.getSecondaryTextColor.value,
                    ),
                  ),
                  Text(
                    SharedMethod.formatValueToCurrency(total, decimalDigits: 0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding / 2),
          Expanded(
            child: CustomButton(
              height: 35,
              padding: EdgeInsets.zero,
              label: 'Beli',
              enable: _cartController.selectedProducts.value.isNotEmpty,
              onTap: onTapBuyButton,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderContent() {
    return _cartController.selectedProducts.value.isEmpty
        ? const EmptyWidget()
        : ListView.separated(
            itemCount: _cartController.selectedProducts.value.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) => CartCard(index: index),
          );
  }
}
