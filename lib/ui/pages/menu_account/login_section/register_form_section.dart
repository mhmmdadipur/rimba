part of '../login_page.dart';

enum PickerType { image, gallery, delete }

class RegisterFormSection extends StatefulWidget {
  const RegisterFormSection({
    super.key,
  });

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection> {
  final UserController _userController = Get.find();
  final ThemeController _themeController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<bool> _isAgree = Rx<bool>(true);
  Rx<File?> _selectedImage = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Rimba Ananta Vikasa';
    _emailController.text = 'rimbahouse1@gmail.com';
    _phoneNumberController.text = '08123456789';
    _passwordController.text = 'testapi';
    _rePasswordController.text = 'testapi';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
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

  void actionAttachmentButton() {
    Future<void> handlePickedFile(XFile file) async {
      _isLoading(true);

      File? compressedImage =
          await SharedMethod.compressImage(file: File(file.path));
      debugPrint(compressedImage.path);
      _selectedImage(compressedImage);

      _isLoading(false);
    }

    Future<void> actionAddAttachmentButton({required PickerType type}) async {
      FocusManager.instance.primaryFocus?.unfocus();

      Map<Permission, PermissionStatus> status =
          await [Permission.camera, Permission.mediaLibrary].request();

      if (status.values.every((element) => element.isGranted)) {
        XFile? file;
        switch (type) {
          case PickerType.image:
            file = await ImagePicker().pickImage(source: ImageSource.camera);
            break;
          case PickerType.gallery:
            file = await ImagePicker().pickMedia();
            break;
          default:
            Get.back();
            _selectedImage.update((_) => _selectedImage = Rx<File?>(null));
        }

        if (file != null) {
          Get.back();
          await handlePickedFile(file);
        }
      } else {
        await SharedWidget.renderSettingsBottomModal();
      }
    }

    SharedWidget.renderDefaultBottomModal(
      titleText: 'Select a Media Picker',
      subtitle: 'Select photos and videos from the camera or gallery',
      isExpanded: false,
      paddingContent: const EdgeInsets.all(SharedValue.defaultPadding),
      content: [
        CustomButton(
          onTap: () => actionAddAttachmentButton(type: PickerType.image),
          height: 35,
          color: Colors.blueGrey.shade700,
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.camera, color: Colors.white, size: 20),
              SizedBox(width: SharedValue.defaultPadding / 2),
              Text('Foto',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        CustomButton(
          onTap: () => actionAddAttachmentButton(type: PickerType.gallery),
          height: 35,
          color: Colors.teal.shade700,
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.image, color: Colors.white, size: 20),
              SizedBox(width: SharedValue.defaultPadding / 2),
              Text('Galeri',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        CustomButton(
          onTap: () => actionAddAttachmentButton(type: PickerType.delete),
          height: 35,
          color: Colors.red.shade700,
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.delete, color: Colors.white, size: 20),
              SizedBox(width: SharedValue.defaultPadding / 2),
              Text('Delete',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  void actionRegisterButton() async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (!_isLoading.value) {
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty ||
          _rePasswordController.text.trim().isEmpty) {
        SharedWidget.renderDefaultSnackBar(
            message: 'Please fill in all available forms', isError: true);
        return;
      }

      if (_passwordController.text.trim() !=
          _rePasswordController.text.trim()) {
        SharedWidget.renderDefaultSnackBar(
            message: 'Password does not match', isError: true);
        return;
      }

      _isLoading(true);
      Map formBody = {
        "name": _nameController.text.trim(),
        "phoneNumber": _phoneNumberController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };

      await _userController.register(body: formBody);
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
    // Widget renderImageForm() {
    //   return SizedBox(
    //     width: 90,
    //     height: 90,
    //     child: InkWell(
    //       onTap: actionAttachmentButton,
    //       splashColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //       child: Stack(
    //         alignment: Alignment.bottomRight,
    //         children: [
    //           Container(
    //             width: 90,
    //             height: 90,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               border: Border.all(
    //                   color: _themeController.primaryColor200.value
    //                       .withOpacity(.2)),
    //               color: _themeController.primaryColor200.value.withOpacity(.1),
    //               image: _selectedImage.isRxNull
    //                   ? null
    //                   : DecorationImage(
    //                       image: FileImage(_selectedImage.value!),
    //                       fit: BoxFit.cover),
    //             ),
    //             child: _selectedImage.isNotRxNull
    //                 ? null
    //                 : Icon(Iconsax.building,
    //                     color: _themeController.primaryColor200.value,
    //                     size: 45),
    //           ),
    //           CircleAvatar(
    //             radius: 15,
    //             backgroundColor: Colors.orange.shade700,
    //             child: const Icon(IconlyLight.edit, size: 20),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * .05),
        Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logo_full.png',
                height: Get.height * .04)),
        const SizedBox(height: 20.0),
        const Text('Register',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
        const SizedBox(height: 8),
        const Text('Create New ${SharedValue.appName} Account.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        const SizedBox(height: 28.0),
        // Center(child: Obx(() => renderImageForm())),
        // const SizedBox(height: SharedValue.defaultPadding * 1.5),
        Text("Name",
            style: TextStyle(
                fontSize: 13,
                color: _themeController.getSecondaryTextColor.value)),
        const SizedBox(height: 5.0),
        CustomTextField(
          height: 35,
          textEditingController: _nameController,
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
        const SizedBox(height: 20.0),
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
          prefixIcon: Icon(IconlyLight.message,
              size: 20, color: _themeController.primaryColor200.value),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          hintText: "Type here...",
        ),
        const SizedBox(height: 20.0),
        Text("Phone Number",
            style: TextStyle(
                fontSize: 13,
                color: _themeController.getSecondaryTextColor.value)),
        const SizedBox(height: 5.0),
        CustomTextField(
          height: 35,
          textEditingController: _phoneNumberController,
          keyboardType: TextInputType.text,
          decoration: BoxDecoration(
              border: Border.all(color: _themeController.primaryColor200.value),
              color: _themeController.primaryColor200.value.withOpacity(.15),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(8))),
          prefixIcon: Icon(IconlyLight.call,
              size: 20, color: _themeController.primaryColor200.value),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          hintText: "Type here...",
        ),
        const SizedBox(height: 20.0),
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
        const SizedBox(height: 20.0),
        Text("Confirm Password",
            style: TextStyle(
                fontSize: 13,
                color: _themeController.getSecondaryTextColor.value)),
        const SizedBox(height: 5.0),
        CustomTextField(
          height: 35,
          textEditingController: _rePasswordController,
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
        const SizedBox(height: 14),
        Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Checkbox(
                value: _isAgree.value,
                activeColor: _themeController.primaryColor200.value,
                side: BorderSide(
                    width: 2,
                    color: _themeController.getPrimaryTextColor.value),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        _themeController.getThemeBorderRadius(5))),
                onChanged: (bool? value) => _isAgree(value ?? false),
              ),
            ),
            const SizedBox(width: 5),
            CustomTextWidget(
              style: const TextStyle(fontSize: 13),
              texts: [
                CustomItemText(
                  text: 'I agree to the',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                CustomItemText(text: ' Terms and Privacy', isBold: true),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
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
              label: 'Sign Up',
              onTap: actionRegisterButton,
              padding: const EdgeInsets.all(5),
              color: _themeController.primaryColor200.value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.toNamed(Routes.login);
          },
          child: CustomTextWidget(
            style: const TextStyle(fontSize: 13),
            texts: [
              CustomItemText(text: 'Already have an account? '),
              CustomItemText(text: 'Sign In Instead', isBold: true),
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
