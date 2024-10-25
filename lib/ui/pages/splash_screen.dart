import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenController splashScreenController =
      Get.put(SplashScreenController());

  final ThemeController _themeController = Get.find();

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
    return Scaffold(
      extendBody: true,
      backgroundColor: _themeController.primaryColor200.value,
      body: AnimationConfiguration.staggeredList(
        position: 0,
        duration: const Duration(milliseconds: 500),
        child: SlideAnimation(
          verticalOffset: 30.0,
          child: FadeInAnimation(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Image.asset("assets/images/logo_full.png",
                          color: Colors.white, width: Get.width * .5),
                    ),
                    const Spacer(flex: 3),
                    Text(
                      'Versi : ${SharedMethod.valuePrettier(_themeController.version.value)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
