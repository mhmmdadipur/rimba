import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'transaction_edit_page.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final ThemeController _themeController = Get.find();
  final TransactionController _transactionController = Get.find();

  final RefreshController _refreshController = RefreshController();
  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<List> _products = Rx<List>([]);
  final Rx<int> _totalPrice = Rx<int>(0);
  final Rx<int> _applicationServiceFee = Rx<int>(0);
  final Rx<int> _asuranceFee = Rx<int>(0);

  @override
  void initState() {
    super.initState();

    _transactionController
        .getDetailTransaction(idTransaction: '${Get.arguments}')
        .then((_) => initData());
  }

  @override
  void dispose() {
    _transactionController.detailTransaction = Rx<Map?>(null);

    _refreshController.dispose();

    super.dispose();
  }

  void initData() {
    _products(
        _transactionController.detailTransaction.value?['products'] ?? []);

    _totalPrice(_products.value.fold(0, (sum, item) {
      int qty = item['quantity'] as int;
      return (sum ?? 0) + (qty * 20000);
    }));
    _applicationServiceFee(1000);
    _asuranceFee((_totalPrice * 1 / 100).round());
  }

  void onRefresh() {
    FocusManager.instance.primaryFocus?.unfocus();

    Future.wait([
      _transactionController.getDetailTransaction(
          idTransaction: '${Get.arguments}'),
    ]).then((value) {
      initData();
      _refreshController.refreshCompleted();
    });
  }

  Future<void> onTapEditButton() async {
    var res = await Get.to(() => const TransactionEditPage(),
        arguments: _transactionController.detailTransaction.value);

    if (res != null) {
      _isLoading(true);
      await _transactionController.getDetailTransaction(
          idTransaction: '${Get.arguments}');
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
      await _transactionController.deleteTransaction(
          idTransaction: '${Get.arguments}');
      _isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: const CustomAppBarWidget(
              titleText: 'Detail Transaction',
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Obx(
                  () {
                    if (_transactionController.detailTransaction.isRxNull) {
                      return WaitingWidget();
                    }

                    return SmartRefresher(
                      onRefresh: onRefresh,
                      controller: _refreshController,
                      header: MaterialClassicHeader(
                        color: Colors.white,
                        backgroundColor: _themeController.primaryColor200.value,
                      ),
                      child: _transactionController
                              .detailTransaction.value!.isEmpty
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
    if (_transactionController.detailTransaction.isRxNull) {
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
          CustomButton(
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
            child: Icon(Iconsax.edit, size: 20, color: Colors.orange.shade700),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          CustomButton(
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
          const SizedBox(width: SharedValue.defaultPadding),
          Expanded(
            child: CustomButton(
              height: 35,
              padding: EdgeInsets.zero,
              label: 'Cancel',
              color: Colors.red.shade700,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade700.withOpacity(.6),
                border: Border.all(color: Colors.red.shade700),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.close_circle, size: 20, color: Colors.white),
                  SizedBox(width: SharedValue.defaultPadding / 2),
                  Flexible(
                    child: Text(
                      'Cancel',
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
    var data = _transactionController.detailTransaction.value;

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
        const Text(
          'Invoice Code',
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              SharedMethod.valuePrettier(data?['invoiceNo']),
              maxLines: 1,
              style: const TextStyle(
                height: 1,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Customer Name',
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              SharedMethod.valuePrettier(data?['customer']),
              maxLines: 1,
              style: const TextStyle(
                height: 1,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Products',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _products.value.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) => renderCard(index),
        ),
        const SizedBox(height: 20),
        const Text(
          'Summary Transaction',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        renderDetailRow(
          title: 'Total Harga',
          subtitle: SharedMethod.formatValueToCurrency(_totalPrice.value,
              decimalDigits: 0),
        ),
        renderDetailRow(
          title: 'Asuransi',
          subtitle: SharedMethod.formatValueToCurrency(_asuranceFee.value,
              decimalDigits: 0),
        ),
        renderDetailRow(
          title: 'Biaya Jasa Aplikasi',
          subtitle: SharedMethod.formatValueToCurrency(
              _applicationServiceFee.value,
              decimalDigits: 0),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Divider(
          height: 0,
          color: _themeController.getSecondaryTextColor.value.withOpacity(.3),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        renderDetailRow(
          title: 'Total Belanja',
          subtitle: SharedMethod.formatValueToCurrency(
              _applicationServiceFee.value +
                  _asuranceFee.value +
                  _totalPrice.value,
              decimalDigits: 0),
        ),
        const SizedBox(height: 20),
        const Text(
          'Detail Transaction',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
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
      ],
    );
  }

  Widget renderCard(int index) {
    var data = _products.value[index];

    return SizedBox(
      width: 50,
      height: 50,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              color: _themeController.primaryColor200.value.withOpacity(.2),
            ),
            child: Icon(
              Iconsax.box,
              size: 30,
              color: _themeController.primaryColor200.value,
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SharedMethod.valuePrettier(data?['product']?['name']),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${SharedMethod.valuePrettier(data['quantity'])} x ${SharedMethod.formatValueToCurrency(20000)}',
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
        ],
      ),
    );
  }
}
