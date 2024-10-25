import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../models/custom_status.dart';
import '../../../routes/routes.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'product_add_page.dart';
import 'product_detail_page.dart';

class FilterTempModel {
  final int id;
  final String label;

  FilterTempModel({required this.id, required this.label});
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FocusNode _focusSearchField = FocusNode();

  final ThemeController _themeController = Get.find();
  final ProductController _productController = Get.find();
  final CartController _cartController = Get.find();

  final TextEditingController _searchTextController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  final Rx<List?> _dataView = Rx<List?>(null);

  final int _totalOnceDisplayed = 20;
  int _page = 1;

  @override
  void initState() {
    super.initState();

    if (_productController.listProduct.isRxNull) {
      _productController.getListProduct().then((value) => getRange());
    } else {
      getRange();
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _refreshController.dispose();
    _focusSearchField.dispose();

    super.dispose();
  }

  void onSearch(String text) {
    if (text.isNotEmpty) {
      _dataView(_productController.listProduct.value?.where((element) {
        return '${element['name']}'.toLowerCase().contains(text.toLowerCase());
      }).toList());
    } else {
      _page = 1;
      getRange();
    }
  }

  void onRefresh() {
    FocusManager.instance.primaryFocus?.unfocus();
    _searchTextController.clear();

    Future.wait([
      _productController.getListProduct(),
    ]).then((value) {
      _page = 1;
      getRange();
      _refreshController.refreshCompleted();
    });
  }

  void onLoading() {
    int end;
    List? listProduct = _productController.listProduct.value;
    int totalDifference =
        listProduct?.length ?? 0 - (_page * _totalOnceDisplayed);
    if (totalDifference > 0) {
      end = _page * _totalOnceDisplayed;
    } else {
      end = _page * _totalOnceDisplayed + totalDifference;
    }

    List? temp = listProduct?.getRange(_dataView.value!.length, end).toList();
    if (temp != null) {
      _dataView.update((val) => _dataView.value?.addAll(temp));
    }
    _page += 1;
    _refreshController.loadComplete();
  }

  void getRange() {
    List? listProduct = _productController.listProduct.value;
    if ((listProduct?.length ?? 0) > _totalOnceDisplayed) {
      _dataView(listProduct?.getRange(0, _page * _totalOnceDisplayed).toList());
    } else {
      _dataView(listProduct?.getRange(0, listProduct.length).toList());
    }
    _page += 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(
          canReturn: false,
          title: SizedBox(
            height: 35,
            child: Obx(
              () => CustomTextField(
                focusNode: _focusSearchField,
                textEditingController: _searchTextController,
                keyboardType: TextInputType.text,
                onChanged: onSearch,
                padding: const EdgeInsets.only(left: 15, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _themeController.primaryColor200.value
                          .withOpacity(.2)),
                  borderRadius: BorderRadius.circular(
                      _themeController.getThemeBorderRadius(20)),
                  color: _themeController.primaryColor200.value.withOpacity(.1),
                ),
                hintText: "Search here...",
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: _themeController.primaryColor200.value,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                leadingChildren: [
                  CustomButton(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(5),
                    child: Icon(IconlyLight.search,
                        size: 20,
                        color: _themeController.primaryColor200.value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
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
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 40, height: 56),
              child: Center(
                child: CustomButton(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(5),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Get.to(() => const ProductAddPage());
                    _page -= 1;
                    getRange();
                  },
                  child: const Icon(Iconsax.add),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Obx(
          () => _dataView.isRxNull
              ? WaitingWidget()
              : SmartRefresher(
                  onRefresh: onRefresh,
                  onLoading: onLoading,
                  enablePullUp: _dataView.value!.length <
                      (_productController.listProduct.value?.length ?? 0),
                  controller: _refreshController,
                  header: MaterialClassicHeader(
                      backgroundColor: _themeController.primaryColor200.value,
                      color: Colors.white),
                  child: _dataView.value!.isEmpty
                      ? const EmptyWidget()
                      : renderBody(),
                ),
        ),
      ),
    );
  }

  Widget renderBody() {
    return SingleChildScrollView(
      child: GroupedListView(
        sort: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 90),
        physics: const NeverScrollableScrollPhysics(),
        elements: _dataView.value ?? [],
        groupBy: (element) => SharedMethod.formatValueToDate(
          element['createdAt'],
          convertToLocal: true,
          newPattern: 'dd MMMM yyyy',
        ),
        separator: const SizedBox(height: 15),
        groupSeparatorBuilder: (String groupByValue) {
          String tempDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
          String date = tempDate == groupByValue ? 'Hari Ini' : groupByValue;

          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(
                      _themeController.getThemeBorderRadius(10))),
              child: Text(date, style: const TextStyle(fontSize: 11)),
            ),
          );
        },
        itemBuilder: (context, dynamic element) => renderCard(element),
      ),
    );
  }

  Widget renderCard(Map data) {
    CustomStatus status =
        _productController.generateStatusLabel('${data['deletedAt']}');

    return InkWell(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await Get.to(() => const ProductDetailPage(),
            arguments: '${data['id']}');
        _page -= 1;
        getRange();
      },
      highlightColor: _themeController.primaryColor200.value.withOpacity(.1),
      splashColor: _themeController.primaryColor200.value.withOpacity(.2),
      child: PaddingColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: const EdgeInsets.symmetric(
            horizontal: SharedValue.defaultPadding, vertical: 8),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    _themeController.primaryColor200.value.withOpacity(.2),
                child: Icon(Iconsax.box,
                    color: _themeController.primaryColor200.value),
              ),
              const SizedBox(width: SharedValue.defaultPadding),
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
                    const SizedBox(height: 2),
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
              const SizedBox(width: SharedValue.defaultPadding),
              Container(
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
                    fontSize: 10,
                    color: status.colorStatus,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Last Update',
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _themeController.getSecondaryTextColor.value,
                  ),
                ),
              ),
              const SizedBox(width: SharedValue.defaultPadding),
              Expanded(
                flex: 2,
                child: Text(
                  SharedMethod.formatValueToDate(data['updatedAt'],
                      convertToLocal: true, newPattern: 'HH:mm, dd MMMM yyyy'),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _themeController.getSecondaryTextColor.value,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
