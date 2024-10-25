import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../controllers/controllers.dart';
import '../../shared/shared.dart';
import '../widgets/widgets.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final ThemeController _themeController = Get.find();

  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;

  double minBound = 0;

  double upperBound = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    if (appLifecycleState == AppLifecycleState.resumed) {
      debugPrint('Resume ${SharedValue.appName} Application');
    } else {
      debugPrint('Close ${SharedValue.appName} Application');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        _themeController.setStatusBarMode();

        return Material(
          child: SlidingUpPanel(
            minHeight: 80,
            boxShadow: const [],
            maxHeight: Get.height * .4,
            color: _themeController.getSecondaryBackgroundColor.value,
            border: Border(
              top: BorderSide(
                  color: _themeController.getSecondaryTextColor.value
                      .withOpacity(.3)),
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                _themeController.getThemeBorderRadius(20),
              ),
            ),
            backdropEnabled: true,
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              drawerScrimColor: Colors.transparent,
              body: AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                      verticalOffset: 30.0,
                      child: FadeInAnimation(child: widget.child))),
            ),
            panel: const CustomNavbarWidget(),
          ),
        );
      },
    );
  }
}
