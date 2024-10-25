import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../../../controllers/controllers.dart';
import '../../../shared/shared.dart';
import '../../widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final ThemeController _themeController = Get.find();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reNewPasswordController =
      TextEditingController();

  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _reNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> getSubmitAction() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (_passwordController.text.trim().isEmpty ||
        _newPasswordController.text.trim().isEmpty ||
        _reNewPasswordController.text.trim().isEmpty) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Please fill in all available columns', isError: true);
    } else if (_newPasswordController.text.trim() !=
        _reNewPasswordController.text.trim()) {
      SharedWidget.renderDefaultSnackBar(
          message: 'The password you entered is not the same', isError: true);
    } else {
      var result = await SharedWidget.renderDefaultDialog(
          icon: IconlyLight.password,
          title: 'Are you sure?',
          contentText: 'Are you sure you changed your password?');
      if (result != null) {
        _isLoading(true);
        // bool result = await _userController.changePassword(
        //     oldPassword: _passwordController.text.trim(),
        //     newPassword: _newPasswordController.text.trim(),
        //     confirmPassword: _reNewPasswordController.text.trim());
        if (result) Get.to(() => const PasswordChangeConfirmationPage());
        _isLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBarWidget(
              titleText: 'Change Password',
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(SharedValue.defaultPadding),
              child: CustomResponsiveConstrainedLayout(
                child: CustomCardWidget(
                  child: renderBody(),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => SharedWidget.renderDefaultLoading(isLoading: _isLoading.value),
        )
      ],
    );
  }

  Widget renderBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.all(SharedValue.defaultPadding),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(.1),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ensure that these requirements are met',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.orange)),
              SizedBox(height: 2),
              Text('Minimum 8 characters long, uppercase & symbol',
                  style: TextStyle(fontSize: 12, color: Colors.orange)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Current Password',
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        CustomTextField(
          textEditingController: _passwordController,
          obscureText: true,
          hintText: 'Type here...',
          hintStyle: TextStyle(
              fontSize: 13, color: _themeController.primaryColor200.value),
          prefixIcon: Icon(IconlyBroken.lock,
              color: _themeController.primaryColor200.value),
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
        ),
        const SizedBox(height: 20),
        const Text('New password',
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        CustomTextField(
          textEditingController: _newPasswordController,
          obscureText: true,
          hintText: 'Type here...',
          hintStyle: TextStyle(
              fontSize: 13, color: _themeController.primaryColor200.value),
          prefixIcon: Icon(IconlyBroken.lock,
              color: _themeController.primaryColor200.value),
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('*Note:',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _themeController.getSecondaryTextColor.value)),
            const SizedBox(width: 5),
            const Expanded(
              child: Text('Make sure you remember the password you entered',
                  style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Retype New Password',
            style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        CustomTextField(
          textEditingController: _reNewPasswordController,
          obscureText: true,
          hintText: 'Type here...',
          hintStyle: TextStyle(
              fontSize: 13, color: _themeController.primaryColor200.value),
          prefixIcon: Icon(IconlyBroken.lock,
              color: _themeController.primaryColor200.value),
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
            border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2)),
            borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10)),
            color: _themeController.primaryColor200.value.withOpacity(.1),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('*Note:',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _themeController.getSecondaryTextColor.value)),
            const SizedBox(width: 5),
            const Expanded(
              child: Text(
                  'Make sure the password you type in the top column is exactly the same as the password you typed in the "New password" column',
                  style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomButton(
            height: 40,
            label: 'Submit',
            onTap: getSubmitAction,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxWidth: 160),
            boxShadow: _themeController.getShadowProfile(mode: 2),
          ),
        ),
      ],
    );
  }
}

class PasswordChangeConfirmationPage extends StatelessWidget {
  const PasswordChangeConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: SharedValue.successColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(FontAwesomeIcons.key,
                  size: 80, color: SharedValue.successColor),
            ),
            SizedBox(height: Get.height * .05),
            const Text('Success',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            SizedBox(height: Get.height * .02),
            const Text('Your password has been updated',
                style: TextStyle(fontSize: 14)),
            SizedBox(height: Get.height * .05),
            CustomButton(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              color: SharedValue.successColor,
              onTap: () => Get.back(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconlyBold.home, size: 18, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Return to the main page',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
