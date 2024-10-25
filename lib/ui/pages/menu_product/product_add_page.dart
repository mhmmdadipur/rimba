import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final FocusNode _focusSalaryAmount = FocusNode();

  final ThemeController _themeController = Get.find();
  final ProductController _productController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final MoneyMaskedTextController _salaryAmountController =
      MoneyMaskedTextController(
          initialValue: 0, precision: 0, decimalSeparator: '');

  final Rx<bool> _isLoading = Rx<bool>(false);

  @override
  void initState() {
    super.initState();

    _focusSalaryAmount.addListener(onFocusSalaryTextFieldChange);
  }

  @override
  void dispose() {
    _focusSalaryAmount.removeListener(onFocusSalaryTextFieldChange);

    _nameController.dispose();
    _salaryAmountController.dispose();

    super.dispose();
  }

  void onFocusSalaryTextFieldChange() {
    if (!_focusSalaryAmount.hasFocus && _salaryAmountController.text.isEmpty) {
      _salaryAmountController.text = '0';
    }
  }

  Future<void> onTapSubmitButton() async {
    FocusManager.instance.primaryFocus!.unfocus();

    String name = _nameController.text.trim();
    String temp = _salaryAmountController.text.trim().replaceAll('.', '');
    int? salaryAmount = int.tryParse(temp);

    if (name.isEmpty || salaryAmount == null) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Please fill in all available forms', isError: true);
      return;
    }

    Map dataForm = {'name': name};

    var res = await SharedWidget.renderDefaultDialog(
      icon: Iconsax.send_2,
      backgroundIconColor: Colors.teal.shade700,
      title: 'Are you sure?',
      contentText: 'Are you sure you want to submit this data?',
    );

    if (res != null) {
      _isLoading(true);
      await _productController.createProduct(body: dataForm);
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
              titleText: 'Add Product',
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                renderContent(),
                renderButton(),
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
    return ListView(
      padding:
          const EdgeInsets.all(SharedValue.defaultPadding).copyWith(bottom: 90),
      children: [
        const Text(
          'Name Product',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 35,
          textEditingController: _nameController,
          keyboardType: TextInputType.text,
          padding: const EdgeInsets.only(left: 15, right: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
          hintText: "e.g. Product A",
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
          'Product Price',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        CustomTextField(
          height: 35,
          autofocus: false,
          focusNode: _focusSalaryAmount,
          textEditingController: _salaryAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          hintStyle: TextStyle(
            fontSize: 13,
            color: _themeController.primaryColor200.value,
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Text(
            'Rp.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: _themeController.getPrimaryTextColor.value,
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
            borderRadius: BorderRadius.circular(
              _themeController.getThemeBorderRadius(10),
            ),
          ),
        ),
      ],
    );
  }
}
