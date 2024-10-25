import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pinput/pinput.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final FocusNode focusNode = FocusNode();
  Timer? timer;

  final ThemeController _themeController = Get.find();
  final UserController _userController = Get.find();

  final TextEditingController _textEditingController = TextEditingController();

  final Rx<Map> arguments = Rx<Map>(Get.arguments);
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
    _textEditingController.dispose();
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

  Future<void> onVerifyOTP(String pin) async {
    _isLoading(true);

    await Future.delayed(const Duration(seconds: 3));

    bool result = await _userController.verifyOTPCode(
      username: arguments.value['username'],
      password: arguments.value['password'],
      pin: pin,
    );

    _isError(!result);

    _isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SharedValue.defaultPadding),
        child: CustomResponsiveConstrainedLayout(
          child: CustomCardWidget(
            child: Obx(() => renderBody()),
          ),
        ),
      ),
    );
  }

  Widget renderBody() {
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
          'Code has been sent to ${SharedMethod.valuePrettier(arguments.value['phone'])}',
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
            controller: _textEditingController,
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
        Text(
          'Didn\'t receive OTP Code?',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _themeController.getPrimaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding / 2),
        Text(
          'Resend Code${_countdown.value == 0 ? '' : ' in ${'${(Duration(seconds: _countdown.value))}'.split('.')[0].padLeft(8, '0')}'}',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: _countdown.value == 0
                  ? _themeController.primaryColor200.value
                  : _themeController.getSecondaryTextColor.value),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              height: 30,
              color: _countdown.value == 0 && !_isLoading.value
                  ? _themeController.primaryColor300.value
                  : _themeController.getSecondaryTextColor.value
                      .withOpacity(.5),
              constraints: const BoxConstraints(minWidth: 100),
              padding: const EdgeInsets.symmetric(
                horizontal: SharedValue.defaultPadding,
              ),
              onTap: startTimer,
              child: const Row(
                children: [
                  Icon(Iconsax.sms, size: 20, color: Colors.white),
                  SizedBox(width: SharedValue.defaultPadding / 2),
                  Text(
                    'Resend to E-mail',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SharedValue.defaultPadding),
            CustomButton(
              height: 30,
              color: _countdown.value == 0 && !_isLoading.value
                  ? _themeController.primaryColor300.value
                  : _themeController.getSecondaryTextColor.value
                      .withOpacity(.5),
              constraints: const BoxConstraints(minWidth: 100),
              padding: const EdgeInsets.symmetric(
                horizontal: SharedValue.defaultPadding,
              ),
              onTap: startTimer,
              child: const Row(
                children: [
                  Icon(Iconsax.call, size: 20, color: Colors.white),
                  SizedBox(width: SharedValue.defaultPadding / 2),
                  Text(
                    'Resend to Whatsapp',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding * 4),
        Visibility(
          visible: !_isLoading.value,
          child: CustomButton(
            height: 35,
            label: 'Verify OTP Code',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxWidth: 400),
            onTap: () => onVerifyOTP(_textEditingController.text),
          ),
        ),
        Visibility(
          visible: _isLoading.value,
          child: Center(
            child: SizedBox(
              height: 30,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [_themeController.primaryColor200.value]),
            ),
          ),
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
}
