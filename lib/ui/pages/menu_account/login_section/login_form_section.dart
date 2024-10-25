part of '../login_page.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({
    super.key,
  });

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  final UserController _userController = Get.find();
  final ThemeController _themeController = Get.find();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<bool> _isRememberMe = Rx<bool>(true);

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      _emailController.text = Get.arguments['email'];
      _passwordController.text = Get.arguments['password'];
    } else {
      _emailController.text = 'rimbahouse@gmail.com';
      _passwordController.text = 'testapi';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> actionGoogleButton() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (!_isLoading.value) {
      _isLoading(true);
      await Future.delayed(const Duration(seconds: 3));
      // await _userController.loginByGoogle();
      _isLoading(false);
    }
  }

  void actionLoginButton() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (!_isLoading.value) {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        SharedWidget.renderDefaultSnackBar(
            message: 'Please fill in all available forms', isError: true);
        return;
      }

      _isLoading(true);
      await _userController.login(
        isRememberMe: _isRememberMe.value,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: renderForm(),
            ),
          )
        ],
      ),
    );
  }

  Widget renderForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * .05),
        Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logo_full.png',
                height: Get.height * .04)),
        const SizedBox(height: 20.0),
        const Text('Sign In',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
        const SizedBox(height: 8),
        const Text(
            'Access the ${SharedValue.appName} panel using your email and passcode.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        const SizedBox(height: 28.0),
        Text("Email Address",
            style: TextStyle(
                fontSize: 13,
                color: _themeController.getSecondaryTextColor.value)),
        const SizedBox(height: 5.0),
        CustomTextField(
          height: 35,
          textEditingController: _emailController,
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
              border: Border.all(color: _themeController.primaryColor200.value),
              color: _themeController.primaryColor200.value.withOpacity(.15),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(8))),
          prefixIcon: Icon(IconlyLight.profile,
              size: 20, color: _themeController.primaryColor200.value),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          hintText: "Type here...",
        ),
        const SizedBox(height: 28.0),
        Text("Password",
            style: TextStyle(
                fontSize: 13,
                color: _themeController.getSecondaryTextColor.value)),
        const SizedBox(height: 5.0),
        CustomTextField(
          height: 35,
          textEditingController: _passwordController,
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
              border: Border.all(color: _themeController.primaryColor200.value),
              color: _themeController.primaryColor200.value.withOpacity(.15),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(8))),
          prefixIcon: Icon(IconlyLight.unlock,
              size: 20, color: _themeController.primaryColor200.value),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          hintText: "***********",
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Obx(
              () => SizedBox(
                width: 28,
                height: 28,
                child: Checkbox(
                  value: _isRememberMe.value,
                  activeColor: _themeController.primaryColor200.value,
                  side: BorderSide(
                      width: 2,
                      color: _themeController.getPrimaryTextColor.value),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          _themeController.getThemeBorderRadius(5))),
                  onChanged: (bool? value) => _isRememberMe(value ?? false),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Text('Remember me?',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            const Spacer(),
            InkWell(
              onTap: () => Get.to(() => const ForgotPasswordPage()),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text('Forgot Password?',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Obx(
          () => Visibility(
            visible: _isLoading.value,
            child: Center(
              child: SizedBox(
                height: 30,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballPulseSync,
                  colors: [_themeController.primaryColor200.value],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: !_isLoading.value,
            child: CustomButton(
              height: 40,
              label: 'Sign In',
              padding: const EdgeInsets.all(5),
              onTap: actionLoginButton,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            var result = await Get.toNamed(Routes.register);
            if (result != null) {
              _emailController.text = result['email'];
              _passwordController.text = result['password'];
            }
          },
          child: CustomTextWidget(
            style: const TextStyle(fontSize: 13),
            texts: [
              CustomItemText(text: 'New on our platform? '),
              CustomItemText(text: 'Create an account', isBold: true),
            ],
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        Row(
          children: [
            Expanded(
              child: Divider(
                  color: _themeController.getPrimaryTextColor.value
                      .withOpacity(.1)),
            ),
            const SizedBox(width: 10),
            Text(
              "OR",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _themeController.getSecondaryTextColor.value),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Divider(
                  color: _themeController.getPrimaryTextColor.value
                      .withOpacity(.1)),
            ),
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              height: 40,
              width: 100,
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(maxWidth: 300),
              onTap: actionGoogleButton,
              decoration: const BoxDecoration(color: Color(0xff1877f2)),
              child: Obx(
                () => _isLoading.value
                    ? const Center(
                        child: SizedBox(
                          height: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballPulseSync,
                            colors: [Colors.white],
                          ),
                        ),
                      )
                    : SvgPicture.asset('assets/icons/logo_facebook.svg',
                        width: 25,
                        height: 25,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn)),
              ),
            ),
            CustomButton(
              height: 40,
              width: 100,
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(maxWidth: 300),
              onTap: actionGoogleButton,
              decoration: BoxDecoration(
                color: _themeController.getSecondaryBackgroundColor.value,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => _isLoading.value
                    ? Center(
                        child: SizedBox(
                          height: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballPulseSync,
                            colors: [_themeController.primaryColor200.value],
                          ),
                        ),
                      )
                    : SvgPicture.asset('assets/icons/logo_google.svg',
                        height: 25, width: 25),
              ),
            ),
            CustomButton(
              height: 40,
              width: 100,
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(maxWidth: 300),
              onTap: actionGoogleButton,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () => _isLoading.value
                    ? const Center(
                        child: SizedBox(
                          height: 30,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballPulseSync,
                            colors: [Colors.white],
                          ),
                        ),
                      )
                    : SvgPicture.asset('assets/icons/logo_apple.svg',
                        width: 25,
                        height: 25,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn)),
              ),
            ),
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding * 2),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Center(
            child: CustomTextWidget(
              style: const TextStyle(fontSize: 13),
              texts: [
                CustomItemText(
                  text: 'Copyright © 2023 ',
                  style: TextStyle(
                    color: _themeController.getSecondaryTextColor.value,
                  ),
                ),
                CustomItemText(text: SharedValue.creatorName, isBold: true),
                CustomItemText(
                  text: '. All rights reserved',
                  style: TextStyle(
                    color: _themeController.getSecondaryTextColor.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
