import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../models/custom_data_log.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class LogDetailItem {
  bool isExpanded;
  String header, value;

  LogDetailItem({
    required this.isExpanded,
    required this.header,
    required this.value,
  });
}

class LogsDetailPage extends StatefulWidget {
  const LogsDetailPage({super.key});

  @override
  State<LogsDetailPage> createState() => _LogsDetailPageState();
}

class _LogsDetailPageState extends State<LogsDetailPage> {
  final DatabaseController _logController = Get.find();
  final ThemeController _themeController = Get.find();

  final RefreshController _refreshController = RefreshController();

  Rx<CustomDataLog?> detailLog = Rx<CustomDataLog?>(null);
  Rx<int> selectedIndexDetail = Rx<int>(2);

  @override
  void initState() {
    super.initState();
    _logController.readLog(Get.arguments).then((value) {
      detailLog(value);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void getRefreshAction() {
    Future.wait([
      _logController.readAllLog(),
    ]).then((value) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          titleText: 'Logs Detail',
          backgroundColor: _themeController.getBlendColor(context)),
      body: Obx(
        () => SmartRefresher(
          controller: _refreshController,
          header: MaterialClassicHeader(
              backgroundColor: _themeController.primaryColor200.value,
              color: Colors.white),
          onRefresh: getRefreshAction,
          child: detailLog.isRxNull ? WaitingWidget() : renderBody(),
        ),
      ),
    );
  }

  Widget renderBody() {
    return ListView(
      children: [
        Material(
          elevation: 2,
          child: ListTile(
            tileColor: _themeController.getBlendColor(context),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: SharedValue.defaultPadding, vertical: 10),
            title: PaddingRow(
              padding: const EdgeInsets.only(bottom: 10),
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  _themeController.getThemeBorderRadius(5)),
                              color: _themeController.primaryColor200.value,
                            ),
                            child: Text(
                                SharedMethod.valuePrettier(
                                    detailLog.value?.method),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              SharedMethod.valuePrettier(
                                  detailLog.value?.title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      Text(SharedMethod.valuePrettier(detailLog.value?.url),
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: _themeController.primaryColor200.value,
                  child: Icon(
                      (detailLog.value?.isDone ?? false)
                          ? EvaIcons.checkmarkCircle
                          : FontAwesomeIcons.clockRotateLeft,
                      size: 16,
                      color: Colors.white),
                )
              ],
            ),
            subtitle: Row(
              children: [
                Icon(EvaIcons.calendarOutline,
                    color: _themeController.primaryColor200.value),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Created at', style: TextStyle(fontSize: 12)),
                      Text(
                          detailLog.value?.createdAt != null
                              ? DateFormat('HH:mm, dd MMM yyyy')
                                  .format(detailLog.value!.createdAt)
                              : '...',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Icon(EvaIcons.calendarOutline,
                    color: _themeController.primaryColor200.value),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Updated at', style: TextStyle(fontSize: 12)),
                      Text(
                          detailLog.value?.updatedAt != null
                              ? DateFormat('HH:mm, dd MMM yyyy')
                                  .format(detailLog.value!.updatedAt)
                              : '...',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ExpansionPanelList(
          expansionCallback: (panelIndex, isExpanded) {
            if (panelIndex == selectedIndexDetail.value) {
              selectedIndexDetail(-1);
            } else {
              selectedIndexDetail(panelIndex);
            }
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: _themeController.getBlendColor(context),
              isExpanded: selectedIndexDetail.value == 0,
              headerBuilder: (context, isExpanded) =>
                  const ListTile(title: Text('Header')),
              body: ListTile(
                title: Text(SharedMethod.valuePrettier(detailLog.value?.header),
                    style: const TextStyle(fontSize: 13)),
                onTap: () =>
                    SharedMethod.copyToClipboard('${detailLog.value?.header}'),
              ),
            ),
            ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: _themeController.getBlendColor(context),
              isExpanded: selectedIndexDetail.value == 1,
              headerBuilder: (context, isExpanded) =>
                  const ListTile(title: Text('Body')),
              body: ListTile(
                title: Text(SharedMethod.valuePrettier(detailLog.value?.body),
                    style: const TextStyle(fontSize: 13)),
                onTap: () =>
                    SharedMethod.copyToClipboard('${detailLog.value?.body}'),
              ),
            ),
            ExpansionPanel(
              canTapOnHeader: true,
              backgroundColor: _themeController.getBlendColor(context),
              isExpanded: selectedIndexDetail.value == 2,
              headerBuilder: (context, isExpanded) =>
                  const ListTile(title: Text('Response')),
              body: ListTile(
                title: Text(
                    SharedMethod.valuePrettier(detailLog.value?.response),
                    style: const TextStyle(fontSize: 13)),
                onTap: () => SharedMethod.copyToClipboard(
                    '${detailLog.value?.response}'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
