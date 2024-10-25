import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  final FocusNode _qtyFocusNode = FocusNode();

  final ThemeController _themeController = Get.find();
  final CartController _cartController = Get.find();

  final TextEditingController _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _qtyController.text = SharedMethod.formatValueToDecimal(
        _cartController.selectedProducts.value[widget.index]['quantity'],
        replace: '0');

    _qtyController.addListener(onFocusQtyFieldChange);
  }

  @override
  void dispose() {
    _qtyController.removeListener(onFocusQtyFieldChange);

    _qtyController.dispose();

    super.dispose();
  }

  void onFocusQtyFieldChange() {
    if (!_qtyFocusNode.hasFocus) {
      if (_qtyController.text.isEmpty) {
        _qtyController.text = '0';
        _cartController.selectedProducts.update((_) => _cartController
            .selectedProducts.value[widget.index]['quantity'] = 0);
      } else {
        int? qty =
            int.tryParse(_qtyController.text.replaceAll(RegExp(r'[^0-9]'), ''));
        if (qty == null) {
          _qtyController.text = SharedMethod.formatValueToDecimal('0');
        }
        _cartController.selectedProducts.update((_) => _cartController
            .selectedProducts.value[widget.index]['quantity'] = qty ?? 0);
      }
    }
  }

  void onPlusAction() {
    int? value =
        int.tryParse(_qtyController.text.replaceAll(RegExp(r'[^0-9]'), ''));

    if (value != null) {
      int result = value + 1;
      _qtyController.text = SharedMethod.formatValueToDecimal(result);
      _cartController.selectedProducts.update((_) => _cartController
          .selectedProducts.value[widget.index]['quantity'] = result);
    } else {
      _qtyController.text = SharedMethod.formatValueToDecimal('0');
      _cartController.selectedProducts.update((_) =>
          _cartController.selectedProducts.value[widget.index]['quantity'] = 0);
    }
  }

  void onMinusAction() {
    int? value =
        int.tryParse(_qtyController.text.replaceAll(RegExp(r'[^0-9]'), ''));

    if (value != null) {
      if (value > 0) {
        int result = value - 1;
        _qtyController.text = SharedMethod.formatValueToDecimal(result);
        _cartController.selectedProducts.update((_) => _cartController
            .selectedProducts.value[widget.index]['quantity'] = result);
      }
    } else {
      _qtyController.text = SharedMethod.formatValueToDecimal('0');
      _cartController.selectedProducts.update((_) =>
          _cartController.selectedProducts.value[widget.index]['quantity'] = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => renderContent());
  }

  Widget renderContent() {
    var data = _cartController.selectedProducts.value[widget.index];

    return SizedBox(
      width: 100,
      height: 100,
      child: PaddingRow(
        padding: const EdgeInsets.symmetric(
            horizontal: SharedValue.defaultPadding, vertical: 8),
        children: [
          Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              color: _themeController.primaryColor200.value.withOpacity(.2),
            ),
            child: Icon(
              Iconsax.box,
              size: 40,
              color: _themeController.primaryColor200.value,
            ),
          ),
          const SizedBox(width: SharedValue.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SharedMethod.valuePrettier(data['name']),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            SharedMethod.formatValueToCurrency(20000),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  _themeController.getSecondaryTextColor.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: SharedValue.defaultPadding),
                    CustomButton(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.zero,
                      label: 'Delete Data',
                      color: Colors.red.shade700,
                      onTap: () => _cartController.removeFromCart(widget.index),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      borderRadius: BorderRadius.circular(
                        _themeController.getThemeBorderRadius(8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700.withOpacity(.2),
                        border: Border.all(color: Colors.red.shade700),
                      ),
                      child: Icon(Iconsax.trash,
                          size: 20, color: Colors.red.shade700),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.zero,
                      onTap: () => onMinusAction(),
                      decoration: BoxDecoration(
                        color: _themeController.primaryColor200.value
                            .withOpacity(.1),
                        borderRadius: BorderRadius.circular(
                            _themeController.getThemeBorderRadius(8)),
                        border: Border.all(
                            color: _themeController.primaryColor200.value,
                            width: 1.2),
                      ),
                      child: Icon(EvaIcons.minus,
                          size: 17,
                          color: _themeController.primaryColor200.value),
                    ),
                    const SizedBox(width: SharedValue.defaultPadding / 2),
                    Expanded(
                      child: CustomTextField(
                        height: 30,
                        autofocus: false,
                        focusNode: _qtyFocusNode,
                        textAlign: TextAlign.center,
                        hintText: 'Ketik disini...',
                        textEditingController: _qtyController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          DecimalFormatter(),
                        ],
                        padding: const EdgeInsets.symmetric(
                            horizontal: SharedValue.defaultPadding),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: _themeController.primaryColor200.value,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _themeController.primaryColor200.value,
                        ),
                        decoration: BoxDecoration(
                          color: _themeController.primaryColor200.value
                              .withOpacity(.1),
                          borderRadius: BorderRadius.circular(
                              _themeController.getThemeBorderRadius(8)),
                          border: Border.all(
                              color: _themeController.primaryColor200.value,
                              width: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: SharedValue.defaultPadding / 2),
                    CustomButton(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.zero,
                      onTap: () => onPlusAction(),
                      decoration: BoxDecoration(
                        color: _themeController.primaryColor200.value
                            .withOpacity(.1),
                        borderRadius: BorderRadius.circular(
                            _themeController.getThemeBorderRadius(8)),
                        border: Border.all(
                            color: _themeController.primaryColor200.value,
                            width: 1.2),
                      ),
                      child: Icon(EvaIcons.plus,
                          size: 17,
                          color: _themeController.primaryColor200.value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
