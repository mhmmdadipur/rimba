import 'dart:async';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FocusNode focusNode = FocusNode();
  Timer? timer;

  final ThemeController _themeController = Get.find();

  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final Rx<int> _countdown = Rx<int>(0);
  final Rx<bool> _isError = Rx<bool>(false);
  final Rx<bool> _isLoading = Rx<bool>(false);

  final int _duration = 180;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpCodeController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    if (_countdown.value == 0) {
      _countdown(_duration);

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown.value == 0) {
          timer.cancel();
        } else {
          _countdown.update((_) => _countdown.value -= 1);
        }
      });
    }
  }

  Future<void> onSendEmail() async {
    _isLoading(true);

    await Future.delayed(const Duration(seconds: 1));
    _isLoading(false);
    _carouselController.nextPage();
  }

  Future<void> onVerifyOTP(String pin) async {
    _isLoading(true);

    await Future.delayed(const Duration(seconds: 1));
    if (pin == '555555') {
      _isLoading(false);
      _isError(false);
      _carouselController.nextPage();
    } else {
      _isLoading(false);
      _isError(true);
    }
  }

  Future<void> onChangePassword() async {
    _isLoading(true);

    await Future.delayed(const Duration(seconds: 1));
    _isLoading(false);
    _carouselController.animateToPage(0);
    SharedWidget.renderDefaultSnackBar(
        message: 'Your password has been changed');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: const CustomAppBarWidget(titleText: 'Forgot Password'),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: SharedValue.defaultPadding),
              child: CustomResponsiveConstrainedLayout(
                child: CarouselSlider(
                  controller: _carouselController,
                  options: CarouselOptions(
                    height: Get.height,
                    reverse: false,
                    autoPlay: false,
                    enlargeFactor: 0.3,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                  ),
                  items: [
                    renderFormCard(
                      child: Obx(() => renderFormSendEmail()),
                    ),
                    renderFormCard(
                      child: Obx(() => renderFormConfirmationPin()),
                    ),
                    renderFormCard(
                      child: Obx(() => renderFormChangePassword()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => SharedWidget.renderDefaultLoading(isLoading: _isLoading.value),
        ),
      ],
    );
  }

  Widget renderFormSendEmail() {
    return Column(
      children: [
        const SizedBox(height: SharedValue.defaultPadding),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _themeController.primaryColor200.value,
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
          ),
          child: Icon(MdiIcons.fingerprint, color: Colors.white, size: 40),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Text(
          'Forgot Password?',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _themeController.getPrimaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Text(
          'Enter the email address associated with your account.',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _themeController.getSecondaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: CustomTextField(
            height: 35,
            textEditingController: _emailController,
            keyboardType: TextInputType.emailAddress,
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(10)),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            hintText: "Type here...",
            style: const TextStyle(fontSize: 13),
            textInputAction: TextInputAction.search,
            hintStyle: TextStyle(
                fontSize: 13, color: _themeController.primaryColor200.value),
            prefixIcon: Icon(Iconsax.sms,
                size: 20, color: _themeController.primaryColor200.value),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 3),
        CustomButton(
          height: 35,
          label: 'Send Reset Link',
          onTap: () => onSendEmail(),
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
          padding: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
        ),
      ],
    );
  }

  Widget renderFormCard({required Widget child}) {
    return CustomCardWidget(
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Center(
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget renderFormConfirmationPin() {
    double defaultWidth = 70;
    double defaultHeight = 50;

    final defaultPinTheme = PinTheme(
      width: defaultWidth,
      height: defaultHeight,
      textStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _themeController.primaryColor300.value),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
        color: _themeController.primaryColor200.value.withOpacity(.1),
      ),
    );
    return Column(
      children: [
        const SizedBox(height: SharedValue.defaultPadding),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _themeController.primaryColor200.value,
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
          ),
          child: const Icon(Iconsax.monitor_mobbile,
              color: Colors.white, size: 40),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Text(
          'Verify your OTP',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _themeController.getPrimaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Text(
          'Code has been sent to ${_emailController.text.trim()}',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _themeController.getSecondaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        SizedBox(
          height: 50 + 5,
          child: Pinput(
            length: 6,
            focusNode: focusNode,
            forceErrorState: _isError.value,
            controller: _otpCodeController,
            onCompleted: (pin) => onVerifyOTP(pin),
            defaultPinTheme: defaultPinTheme,
            submittedPinTheme: defaultPinTheme.copyWith(
              textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _themeController.primaryColor300.value),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              width: defaultWidth + 5,
              height: defaultHeight + 5,
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(
                  color: _themeController.primaryColor300.value,
                ),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700),
              decoration: BoxDecoration(
                color: Colors.red.shade700.withOpacity(.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 3),
        CustomButton(
          height: 35,
          label: 'Send Reset Link',
          onTap: () => onVerifyOTP(_otpCodeController.text),
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
          padding: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
        ),
        Visibility(
            visible: _isError.value,
            child: const SizedBox(height: SharedValue.defaultPadding)),
        Visibility(
          visible: _isError.value,
          child: Text(
            'Your OTP code is not valid, please try again.',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.red.shade700),
          ),
        ),
      ],
    );
  }

  Widget renderFormChangePassword() {
    return Column(
      children: [
        const SizedBox(height: SharedValue.defaultPadding),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _themeController.primaryColor200.value,
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
          ),
          child:
              Icon(MdiIcons.formTextboxPassword, color: Colors.white, size: 40),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Text(
          'Change Password',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: _themeController.getPrimaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Text(
          'Enter new password for your account,\nmake sure it is strong.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _themeController.getSecondaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("New Password",
              style: TextStyle(
                  fontSize: 13,
                  color: _themeController.getSecondaryTextColor.value)),
        ),
        const SizedBox(height: SharedValue.defaultPadding / 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: CustomTextField(
            height: 35,
            keyboardType: TextInputType.emailAddress,
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(10)),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            hintText: "***********",
            obscureText: true,
            style: const TextStyle(fontSize: 13),
            textInputAction: TextInputAction.search,
            hintStyle: TextStyle(
                fontSize: 13, color: _themeController.primaryColor200.value),
            prefixIcon: Icon(IconlyLight.unlock,
                size: 20, color: _themeController.primaryColor200.value),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Confirm New Password",
              style: TextStyle(
                  fontSize: 13,
                  color: _themeController.getSecondaryTextColor.value)),
        ),
        const SizedBox(height: SharedValue.defaultPadding / 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: CustomTextField(
            height: 35,
            keyboardType: TextInputType.emailAddress,
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(10)),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            hintText: "***********",
            obscureText: true,
            style: const TextStyle(fontSize: 13),
            textInputAction: TextInputAction.search,
            hintStyle: TextStyle(
                fontSize: 13, color: _themeController.primaryColor200.value),
            prefixIcon: Icon(IconlyLight.unlock,
                size: 20, color: _themeController.primaryColor200.value),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 3),
        CustomButton(
          height: 35,
          label: 'Send Reset Link',
          onTap: () => onChangePassword(),
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
          padding: const EdgeInsets.symmetric(
              horizontal: SharedValue.defaultPadding),
        ),
      ],
    );
  }
}
