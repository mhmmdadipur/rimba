import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controllers/controllers.dart';
import '../../../models/custom_item_text.dart';
import '../../../routes/routes.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';
import 'forgot_password_page.dart';

part 'login_section/login_form_section.dart';
part 'login_section/register_form_section.dart';

class LoginPage extends StatefulWidget {
  final Widget child;

  const LoginPage({
    super.key,
    required this.child,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(child: widget.child))),
              ),
              if (!CustomResponsiveWidget.isMobile(context))
                Expanded(child: renderBodyRight())
            ],
          ),
        ),
      ),
    );
  }

  Widget renderBodyRight() {
    Widget renderCard({
      required String title,
      required IconData icon,
    }) {
      return Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(30)),
            border: Border.all(
                width: 1.5, color: SharedValue.backgroundLightColor100)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: SharedValue.backgroundLightColor100),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SharedValue.backgroundLightColor100),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipPath(
        clipper:
            CardClipper(distance: 80 * .3, circleRadius: 80, onRight: false),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/wallpaper.jpg'),
            ),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.3),
                borderRadius: BorderRadius.circular(40)),
            child: PaddingColumn(
              padding: const EdgeInsets.all(40),
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Tasks Organized & Trackable",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: SharedValue.backgroundLightColor100),
                ),
                const SizedBox(height: 10),
                const Text(
                  "A system that can help solve your work reporting problems",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: SharedValue.backgroundLightColor100),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: renderCard(
                        title: 'Dummy Tag 1',
                        icon: Iconsax.info_circle,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: renderCard(
                        title: 'Dummy Tag 2',
                        icon: Iconsax.info_circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
