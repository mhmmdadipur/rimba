import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../controllers/controllers.dart';
import '../../../../extensions/extensions.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';
import '../../image_viewer_page.dart';

class AccountPersonalAddressSection extends StatefulWidget {
  const AccountPersonalAddressSection({
    super.key,
    required this.pageController,
    required this.selectedPage,
  });

  final PageController pageController;
  final Rx<int> selectedPage;

  @override
  State<AccountPersonalAddressSection> createState() =>
      _AccountPersonalAddressSectionState();
}

class _AccountPersonalAddressSectionState
    extends State<AccountPersonalAddressSection> {
  final ThemeController _themeController = Get.find();
  final UserController _userController = Get.find();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();

  final Rx<bool> _isLoading = Rx<bool>(false);
  final Rx<File?> _selectedFile = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    _addressController.text = SharedMethod.valuePrettier(
        _userController.user.value?['address'],
        replace: '');
    _postalCodeController.text = SharedMethod.valuePrettier(
        _userController.user.value?['postal_code'],
        replace: '');
    _nationalIdController.text = SharedMethod.valuePrettier(
        _userController.user.value?['national_id'],
        replace: '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _postalCodeController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void actionAttachmentButton() {
    SharedWidget.renderDefaultBottomModal(
      titleText: 'Select a Media',
      subtitle: 'Select photos and videos from the camera or gallery',
      isExpanded: false,
      paddingContent: const EdgeInsets.all(16),
      content: [
        Visibility(
          visible: _selectedFile.isNotRxNull,
          child: CustomButton(
            onTap: () {
              Get.back();
              Get.to(ImageViewerPage(
                  isNetworkImage: false, file: _selectedFile.value));
            },
            height: 35,
            color: Colors.blue,
            padding: EdgeInsets.zero,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconlyBroken.camera, color: SharedValue.textDarkColor200),
                SizedBox(width: 10),
                Text('VIiw Image',
                    style: TextStyle(
                        color: SharedValue.textDarkColor200,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        Visibility(
            visible: _selectedFile.isNotRxNull,
            child: const SizedBox(height: 10)),
        CustomButton(
          onTap: () => actionAddAttachmentButton(type: 'image'),
          height: 35,
          color: _themeController.primaryColor200.value,
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.camera, color: SharedValue.textDarkColor200),
              SizedBox(width: 10),
              Text('Foto',
                  style: TextStyle(
                      color: SharedValue.textDarkColor200,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
          onTap: () => actionAddAttachmentButton(type: 'gallery'),
          height: 38,
          color: Colors.teal.shade300,
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(IconlyBroken.image, color: SharedValue.textDarkColor200),
              SizedBox(width: 10),
              Text('Galeri',
                  style: TextStyle(
                      color: SharedValue.textDarkColor200,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> actionAddAttachmentButton({required String type}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.mediaLibrary,
    ].request();

    if (status.values.every((element) => element.isGranted)) {
      _isLoading(true);
      XFile? file;
      switch (type) {
        case 'image':
          file = await ImagePicker().pickImage(source: ImageSource.camera);
          break;
        case 'gallery':
          file = await ImagePicker().pickImage(source: ImageSource.gallery);
          break;
        default:
          throw Exception('Unsupported file type: $type');
      }
      if (file != null) {
        Get.back();
        await handlePickedFile(file);
      }
    } else {
      await SharedWidget.renderSettingsBottomModal();
    }
    _isLoading(false);
  }

  Future<void> handlePickedFile(XFile file) async {
    File? compressedImage =
        await SharedMethod.compressImage(file: File(file.path));
    debugPrint(compressedImage.path);

    _selectedFile(compressedImage);

    _isLoading(false);
  }

  Future<void> onTapSubmitButton() async {
    var response = await SharedWidget.renderDefaultDialog(
      icon: Iconsax.edit,
      title: 'Edit Personal Address',
      contentText: 'Are you sure want to edit your personal address?',
    );

    if (response != null) {
      widget.selectedPage(2);
      widget.pageController.animateToPage(2,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding:
          const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding)
              .copyWith(bottom: 90),
      children: [
        Text(
          'Foto KTP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _themeController.getSecondaryTextColor.value,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: actionAttachmentButton,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            child: Row(
              children: [
                const Icon(
                  IconlyBold.image,
                  size: 35,
                ),
                const SizedBox(width: SharedValue.defaultPadding / 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Silahkan Pilih File',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: _themeController.getSecondaryTextColor.value,
                        ),
                      ),
                      Text(
                        SharedMethod.valuePrettier(_selectedFile.value?.path,
                            replace: 'Anda belum memilih file'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SharedValue.defaultPadding / 2),
                Obx(() => Visibility(
                    visible: _selectedFile.isNotRxNull,
                    child: const Icon(EvaIcons.checkmarkCircle2,
                        color: Colors.teal, size: 25)))
              ],
            ),
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          icon: Iconsax.user_edit,
          title: 'NIK',
          controller: _nationalIdController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          icon: Iconsax.user_edit,
          title: 'Alamat Sesuai KTP',
          controller: _addressController,
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          icon: Iconsax.message,
          title: 'Postal Code',
          controller: _postalCodeController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding * 3),
        CustomCardWidget.renderRequirementsCard(),
        const SizedBox(height: SharedValue.defaultPadding),
        SizedBox(
          width: Get.width,
          child: Wrap(
            textDirection: TextDirection.rtl,
            spacing: SharedValue.defaultPadding,
            runSpacing: SharedValue.defaultPadding,
            children: [
              CustomButton(
                height: 35,
                width: null,
                label: 'Submit',
                onTap: onTapSubmitButton,
                color: Colors.teal.shade700,
                style: const TextStyle(fontSize: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: SharedValue.defaultPadding * 1.5),
                constraints: const BoxConstraints(maxWidth: 160),
                boxShadow: _themeController.getShadowProfile(mode: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget renderTextForm({
    required String title,
    required IconData? icon,
    TextEditingController? controller,
    int? maxLines = 1,
    bool enable = true,
    double? height = 35,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType = TextInputType.text,
    EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10),
  }) {
    return CustomTextField(
      title: title,
      enable: enable,
      height: height,
      maxLines: maxLines,
      padding: padding,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      showClearButton: enable ? maxLines == 1 : false,
      textEditingController: controller,
      decoration: BoxDecoration(
        border: Border.all(
            color: (enable
                    ? _themeController.primaryColor200.value
                    : _themeController.getSecondaryTextColor.value)
                .withOpacity(.2)),
        borderRadius: BorderRadius.circular(
          _themeController.getThemeBorderRadius(10),
        ),
        color: (enable
                ? _themeController.primaryColor200.value
                : _themeController.getSecondaryTextColor.value)
            .withOpacity(.1),
      ),
      hintText: "Type here...",
      style: const TextStyle(fontSize: 13),
      textInputAction: TextInputAction.search,
      hintStyle: TextStyle(
        fontSize: 13,
        color: (enable
            ? _themeController.primaryColor200.value
            : _themeController.getSecondaryTextColor.value),
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: (enable
            ? _themeController.primaryColor200.value
            : _themeController.getSecondaryTextColor.value),
      ),
    );
  }
}
