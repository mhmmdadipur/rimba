import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class TransactionEditPage extends StatefulWidget {
  const TransactionEditPage({super.key});

  @override
  State<TransactionEditPage> createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  final FocusNode _focusSalaryAmount = FocusNode();

  final ThemeController _themeController = Get.find();
  final TransactionController _transactionController = Get.find();

  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();

  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<List> _products = Rx<List>([]);
  final Rx<int> _totalPrice = Rx<int>(0);
  final Rx<int> _applicationServiceFee = Rx<int>(0);
  final Rx<int> _asuranceFee = Rx<int>(0);

  final arguments = Get.arguments;

  @override
  void initState() {
    super.initState();

    if (arguments != null) {
      _invoiceController.text =
          SharedMethod.valuePrettier(arguments['invoiceNo'], replace: '');
      _customerNameController.text =
          SharedMethod.valuePrettier(arguments['customer'], replace: '');
      _products(arguments['products'] ?? []);
    }

    _totalPrice(_products.value.fold(0, (sum, item) {
      int? qty = item['quantity'] as int?;
      int? price = item['price'] as int?;
      return (sum ?? 0) + ((qty ?? 0) * (price ?? 0));
    }));
    _applicationServiceFee(1000);
    _asuranceFee((_totalPrice * 1 / 100).round());
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _invoiceController.dispose();

    super.dispose();
  }

  Future<void> onTapSubmitButton() async {
    FocusManager.instance.primaryFocus!.unfocus();

    String name = _customerNameController.text.trim();
    String invoice = _invoiceController.text.trim();

    if (name.isEmpty || invoice.isEmpty) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Please fill in all available forms', isError: true);
      return;
    }

    List temp = [];
    for (var element in _products.value) {
      temp.add({
        "productId": '${element['product']['id']}',
        "quantity": '${element['quantity']}',
        "price": "${element['price'] ?? 20000}"
      });
    }

    Map dataForm = {
      "invoiceNo": invoice,
      "date": SharedMethod.formatValueToDate(DateTime.now(),
          convertToLocal: true, newPattern: 'yyyy-MM-dd'),
      "customer": name,
      "products": temp,
    };

    debugPrint('$dataForm');
    var res = await SharedWidget.renderDefaultDialog(
      icon: Iconsax.edit,
      backgroundIconColor: Colors.orange.shade700,
      title: 'Are you sure?',
      contentText: 'Are you sure you want to edit this data?',
    );

    if (res != null) {
      _isLoading(true);
      await _transactionController.updateTransaction(
          idTransaction: '${arguments['id']}', body: dataForm);
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
              titleText: 'Edit Transaction',
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
      child: CustomButton(
        height: 35,
        padding: EdgeInsets.zero,
        label: 'Submit Data',
        onTap: onTapSubmitButton,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        borderRadius: BorderRadius.circular(
          _themeController.getThemeBorderRadius(20),
        ),
      ),
    );
  }

  Widget renderContent() {
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
        CustomTextField(
          height: 35,
          enable: false,
          autofocus: false,
          focusNode: _focusSalaryAmount,
          textEditingController: _invoiceController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          hintStyle: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(Iconsax.tag, color: Colors.grey, size: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.2)),
            color: Colors.grey.withOpacity(.1),
            borderRadius: BorderRadius.circular(
              _themeController.getThemeBorderRadius(10),
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
        CustomTextField(
          height: 35,
          textEditingController: _customerNameController,
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
          prefixIcon: const Icon(Iconsax.user, size: 20),
          hintText: "e.g. Customer A",
          hintStyle: TextStyle(
            fontSize: 13,
            color: _themeController.primaryColor200.value,
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
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
