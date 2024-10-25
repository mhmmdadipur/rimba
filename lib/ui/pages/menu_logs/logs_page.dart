import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../models/custom_data_log.dart';
import '../../../models/custom_item_dropdown.dart';
import '../../../routes/routes.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final DatabaseController _logController = Get.find();
  final ThemeController _themeController = Get.find();

  final TextEditingController _searchTextController = TextEditingController();
  final RefreshController _refreshController = RefreshController();

  Rx<List<CustomDataLog>?> dataLog = Rx<List<CustomDataLog>?>(null),
      dataView = Rx<List<CustomDataLog>?>(null);
  int page = 1, totalOnceDisplayed = 20;

  @override
  void initState() {
    super.initState();
    _logController.readAllLog().then((value) {
      dataLog(value);
      _getRange();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  void _getRange() {
    if (dataLog.value!.length > totalOnceDisplayed) {
      dataView(dataLog.value?.getRange(0, page * totalOnceDisplayed).toList());
      page += 1;
    } else {
      dataView(dataLog.value?.getRange(0, dataLog.value!.length).toList());
    }
  }

  void _getSearchAction(String text) {
    if (text.isNotEmpty) {
      dataView(dataLog.value
          ?.where((element) =>
              element.title.toLowerCase().contains(text.toLowerCase()))
          .toList());
    } else {
      page = 1;
      _getRange();
    }
  }

  void _getRefreshAction() {
    Future.wait([_logController.readAllLog()]).then((value) {
      page = 1;
      dataLog(value[0]);
      _getRange();
      _refreshController.refreshCompleted();
    });
  }

  void _getLoadingAction() {
    int end;
    int totalDifference = dataLog.value!.length - (page * totalOnceDisplayed);
    if (totalDifference > 0) {
      end = page * totalOnceDisplayed;
    } else {
      end = page * totalOnceDisplayed + totalDifference;
    }

    List<CustomDataLog>? temp =
        dataLog.value?.getRange(dataView.value!.length, end).toList();
    if (temp != null) {
      dataView.update((val) => dataView.value?.addAll(temp));
    }
    page += 1;
    _refreshController.loadComplete();
  }

  Future<void> getColumnAction() async {
    await _logController.getColumnTable('logs');
  }

  Future<void> getClearAction() async {
    var response = await SharedWidget.renderDefaultDialog(
        icon: IconlyLight.danger,
        title: 'Are you sure?',
        contentText: 'Are you sure you want to delete all logs?');

    if (response != null) {
      _logController.clearLog().then((value) => _getRefreshAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBarWidget(
            titleText: 'Logs',
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Obx(
                () => CustomTextField(
                  height: 35,
                  textEditingController: _searchTextController,
                  keyboardType: TextInputType.text,
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  onChanged: _getSearchAction,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _themeController.primaryColor200.value
                            .withOpacity(.2)),
                    borderRadius: BorderRadius.circular(20),
                    color:
                        _themeController.primaryColor200.value.withOpacity(.1),
                  ),
                  hintText: "Search here...",
                  hintStyle: TextStyle(
                      fontSize: 13,
                      color: _themeController.primaryColor200.value),
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
              const SizedBox(width: 8),
              renderActions(),
              const SizedBox(width: 8),
            ]),
        body: Obx(() => dataView.isRxNull
            ? WaitingWidget()
            : SmartRefresher(
                controller: _refreshController,
                enablePullUp:
                    (page - 1) * totalOnceDisplayed <= dataView.value!.length,
                header: MaterialClassicHeader(
                    backgroundColor: _themeController.primaryColor200.value,
                    color: Colors.white),
                onRefresh: _getRefreshAction,
                onLoading: _getLoadingAction,
                child: dataView.value!.isEmpty
                    ? const EmptyWidget()
                    : renderBody())),
      ),
    );
  }

  Widget renderBody() {
    return SingleChildScrollView(
      child: CustomResponsiveConstrainedLayout(
        child: GroupedListView<CustomDataLog, String>(
          shrinkWrap: true,
          order: GroupedListOrder.DESC,
          physics: const NeverScrollableScrollPhysics(),
          elements: dataView.value ?? [],
          groupBy: (element) =>
              DateFormat('dd MMMM yyyy').format(element.createdAt),
          separator: const SizedBox(height: 10),
          groupSeparatorBuilder: (String groupByValue) {
            String tempDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
            String date = tempDate == groupByValue ? 'Hari Ini' : groupByValue;

            return Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(date, style: const TextStyle(fontSize: 11)),
              ),
            );
          },
          itemBuilder: (context, CustomDataLog element) =>
              generateBranchCard(element),
        ),
      ),
    );
  }

  Widget generateBranchCard(CustomDataLog data) {
    return InkWell(
      onTap: () => Get.toNamed('${Routes.logs}/${data.id}', arguments: data.id),
      splashColor: _themeController.primaryColor200.value.withOpacity(.2),
      highlightColor: _themeController.primaryColor200.value.withOpacity(.1),
      child: PaddingColumn(
        padding: const EdgeInsets.symmetric(
            horizontal: SharedValue.defaultPadding, vertical: 10),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(SharedMethod.valuePrettier(data.title),
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(SharedMethod.valuePrettier(data.url),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 15,
                backgroundColor: _themeController.primaryColor200.value,
                child: Icon(
                    (data.isDone)
                        ? EvaIcons.checkmarkCircle
                        : FontAwesomeIcons.clockRotateLeft,
                    size: 16,
                    color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(SharedMethod.valuePrettier(data.response),
              maxLines: 2, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Created at', style: TextStyle(fontSize: 12)),
                    Text(
                        DateFormat('HH:mm, dd MMM yyyy').format(data.createdAt),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Updated at', style: TextStyle(fontSize: 12)),
                    Text(
                        DateFormat('HH:mm, dd MMM yyyy').format(data.updatedAt),
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderActions() {
    List<CustomItemDropdown> dropDownMenuModel = [
      CustomItemDropdown(
          id: 'column',
          label: 'Column',
          icon: IconlyLight.paper,
          onTap: getColumnAction),
      CustomItemDropdown(
          id: 'clear',
          label: 'clear',
          icon: IconlyLight.delete,
          onTap: getClearAction),
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<CustomItemDropdown>(
        isExpanded: true,
        customButton: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 40, height: 56),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(50))),
            child: const Icon(IconlyLight.more_square),
          ),
        ),
        buttonStyleData: const ButtonStyleData(
            elevation: 0,
            overlayColor: WidgetStatePropertyAll(Colors.transparent)),
        dropdownStyleData: DropdownStyleData(
          width: 150,
          elevation: 0,
          offset: const Offset(0, -5),
          direction: DropdownDirection.left,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: _themeController.getPrimaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(4),
              boxShadow: _themeController.getShadowProfile().copyWith([
                SharedMethod.renderBoxShadow(
                    opacity: .1, blurRadius: 20, dx: 0, dy: -2.77)
              ])),
        ),
        items: List.generate(
          dropDownMenuModel.length,
          (index) => DropdownMenuItem(
            value: dropDownMenuModel[index],
            child: Row(
              children: [
                Icon(dropDownMenuModel[index].icon, size: 20),
                const SizedBox(width: 15),
                Text(dropDownMenuModel[index].label,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14))
              ],
            ),
          ),
        ),
        onChanged: (value) async {
          if (value != null && value.onTap != null) value.onTap!();
        },
      ),
    );
  }
}
