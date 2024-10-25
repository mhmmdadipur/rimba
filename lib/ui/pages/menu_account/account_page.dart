import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../controllers/controllers.dart';
import '../../../extensions/extensions.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'account_section/account_job_information_section.dart';
import 'account_section/account_personal_address_section.dart';
import 'account_section/account_personal_data_section.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ThemeController _themeController = Get.find();
  final UserController _userController = Get.find();

  final PageController _pageController = PageController(initialPage: 0);

  final Rx<bool> _isLoading = Rx<bool>(false);

  final Rx<int> _selectedPage = Rx<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: const CustomAppBarWidget(titleText: 'Account Detail'),
            body: Obx(
              () => _userController.user.isRxNull
                  ? WaitingWidget()
                  : Column(
                      children: [
                        renderHeader(),
                        Expanded(child: renderBody()),
                      ],
                    ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: _isLoading.value,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding),
                alignment: Alignment.center,
                constraints:
                    const BoxConstraints(maxWidth: 400, maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.3),
                  borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(10),
                  ),
                ),
                child: WaitingWidget(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget renderHeader() {
    TextStyle indicatorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );

    LineStyle getBeforeLineStyle(int index) {
      return LineStyle(
        thickness: 6,
        color: index > _selectedPage.value
            ? Colors.grey
            : _themeController.primaryColor200.value,
      );
    }

    LineStyle getAfterLineStyle(int index) {
      return LineStyle(
        thickness: 6,
        color: index > _selectedPage.value
            ? Colors.grey
            : _themeController.primaryColor200.value,
      );
    }

    BoxDecoration getIndicatorBoxDecoration(int index) {
      return BoxDecoration(
        shape: BoxShape.circle,
        color: index > _selectedPage.value
            ? Colors.grey
            : _themeController.primaryColor200.value,
      );
    }

    TextStyle getChildTimelineTextStyle(int index) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: index > _selectedPage.value
              ? Colors.grey
              : _themeController.primaryColor200.value,
        );
    return Container(
      height: 90,
      padding:
          const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding),
      child: Row(
        children: [
          TimelineTile(
            isFirst: true,
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.start,
            beforeLineStyle: getBeforeLineStyle(0),
            afterLineStyle: getAfterLineStyle(0),
            indicatorStyle: IndicatorStyle(
              width: 35,
              height: 35,
              indicator: GestureDetector(
                onTap: () {
                  _selectedPage(0);
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: getIndicatorBoxDecoration(0),
                  child: Text('1', style: indicatorTextStyle),
                ),
              ),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('Biodata Diri',
                  textAlign: TextAlign.center,
                  style: getChildTimelineTextStyle(0)),
            ),
          ),
          Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.start,
              beforeLineStyle: getBeforeLineStyle(1),
              afterLineStyle: getAfterLineStyle(1),
              indicatorStyle: IndicatorStyle(
                width: 35,
                height: 35,
                indicator: GestureDetector(
                  onTap: () {
                    _selectedPage(1);
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: getIndicatorBoxDecoration(1),
                    child: Text('2', style: indicatorTextStyle),
                  ),
                ),
              ),
              endChild: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('Alamat\nPribadi',
                    textAlign: TextAlign.center,
                    style: getChildTimelineTextStyle(1)),
              ),
            ),
          ),
          TimelineTile(
            isLast: true,
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.start,
            afterLineStyle: getAfterLineStyle(2),
            beforeLineStyle: getBeforeLineStyle(2),
            indicatorStyle: IndicatorStyle(
              width: 35,
              height: 35,
              indicator: GestureDetector(
                onTap: () {
                  _selectedPage(2);
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: getIndicatorBoxDecoration(2),
                  child: Text('3', style: indicatorTextStyle),
                ),
              ),
            ),
            endChild: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('Informasi\nPekerjaan',
                  textAlign: TextAlign.center,
                  style: getChildTimelineTextStyle(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderBody() {
    return PageView(
      controller: _pageController,
      onPageChanged: (value) => _selectedPage(value),
      children: [
        AccountPersonalDataSection(
            pageController: _pageController, selectedPage: _selectedPage),
        AccountPersonalAddressSection(
            pageController: _pageController, selectedPage: _selectedPage),
        AccountJobInformationSection(
            pageController: _pageController, selectedPage: _selectedPage)
      ],
    );
  }
}
