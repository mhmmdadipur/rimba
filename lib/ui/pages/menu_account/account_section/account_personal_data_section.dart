import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../controllers/controllers.dart';
import '../../../../extensions/extensions.dart';
import '../../../../shared/shared.dart';
import '../../../widgets/widgets.dart';

class AccountPersonalDataSection extends StatefulWidget {
  const AccountPersonalDataSection({
    super.key,
    required this.pageController,
    required this.selectedPage,
  });

  final PageController pageController;
  final Rx<int> selectedPage;

  @override
  State<AccountPersonalDataSection> createState() =>
      _AccountPersonalDataSectionState();
}

class _AccountPersonalDataSectionState
    extends State<AccountPersonalDataSection> {
  final ThemeController _themeController = Get.find();
  final UserController _userController = Get.find();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final Rx<String?> _selectedGender = Rx<String?>(null);
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  final List<String> _listGender = ['Laki-laki', 'Perempuan'];

  @override
  void initState() {
    super.initState();
    _nameController.text = SharedMethod.valuePrettier(
        _userController.user.value?['full_name'],
        replace: '');
    _usernameController.text = SharedMethod.valuePrettier(
        _userController.user.value?['username'],
        replace: '');
    _emailController.text = SharedMethod.valuePrettier(
        _userController.user.value?['email'],
        replace: '');
    _phoneController.text = SharedMethod.valuePrettier(
        _userController.user.value?['phone_number'],
        replace: '');
    _selectedDate(
        DateTime.tryParse('${_userController.user.value?['date_of_birth']}'));
    _selectedGender(_listGender.firstWhereOrNull(
        (element) => element == _userController.user.value?['gender']));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void renderDatePicker() {
    FocusManager.instance.primaryFocus!.unfocus();
    SharedWidget.renderDefaultBottomModal(
      titleText: 'Select Date of Birth',
      subtitle: 'Please select your date of birth',
      content: [
        SfDateRangePicker(
          maxDate: DateTime.now(),
          backgroundColor: Colors.transparent,
          initialSelectedDate: _selectedDate.value,
          headerStyle: _themeController.getDatePickerHeaderStyle,
          yearCellStyle: _themeController.getDatePickerYearCellStyle,
          monthViewSettings: _themeController.getDatePickerMonthViewStyle,
          monthCellStyle: _themeController.getDatePickerMonthCellStyle,
          rangeTextStyle:
              TextStyle(color: _themeController.getPrimaryTextColor.value),
          selectionTextStyle: const TextStyle(color: Colors.white),
          rangeSelectionColor:
              _themeController.primaryColor200.value.withOpacity(.3),
          selectionMode: DateRangePickerSelectionMode.single,
          showActionButtons: true,
          confirmText: 'Submit',
          cancelText: 'Back',
          onCancel: () => Get.back(),
          onSubmit: (p0) async {
            if (p0 is DateTime) {
              _selectedDate(p0);
            } else {
              SharedWidget.renderDefaultSnackBar(
                  message: 'Something went wrong', isError: true);
            }
            Get.back();
          },
        ),
      ],
    );
  }

  Future<void> onTapSubmitButton() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedGender.isRxNull) {
      SharedWidget.renderDefaultSnackBar(
          message: 'Please fill all field', isError: true);
      return;
    }

    var response = await SharedWidget.renderDefaultDialog(
      icon: Iconsax.edit,
      title: 'Edit Personal Data',
      contentText: 'Are you sure want to edit your personal data?',
    );

    if (response != null) {
      widget.selectedPage(1);
      widget.pageController.animateToPage(1,
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
        renderTextForm(
          icon: Iconsax.user_edit,
          title: 'Nama Lengkap',
          controller: _nameController,
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        Text(
          'Tanggal Lahir',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _themeController.getSecondaryTextColor.value,
          ),
        ),
        const SizedBox(height: 5),
        CustomButton(
          height: 35,
          padding: EdgeInsets.zero,
          onTap: renderDatePicker,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Iconsax.calendar,
                    size: 20, color: _themeController.primaryColor200.value),
              ),
              Obx(
                () => Expanded(
                  child: Text(
                    SharedMethod.formatValueToDate(_selectedDate.value,
                        convertToLocal: true,
                        newPattern: 'dd MMMM yyyy',
                        replace: 'Silahkan Pilih Tanggal'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(EvaIcons.arrowIosForward, size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          enable: false,
          icon: Iconsax.message,
          title: 'Username',
          controller: _usernameController,
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          enable: false,
          icon: Iconsax.message,
          title: 'Alamat Email',
          controller: _emailController,
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        renderTextForm(
          icon: Iconsax.user_edit,
          title: 'No. Telepon',
          controller: _phoneController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(height: SharedValue.defaultPadding * 1.5),
        Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _themeController.getSecondaryTextColor.value,
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => CustomDropdownWidget<String>(
            buttonHeight: 35,
            value: _selectedGender.value,
            onChanged: (value) => _selectedGender(value),
            buttonDecoration: BoxDecoration(
              border: Border.all(
                color: _themeController.primaryColor200.value.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(
                _themeController.getThemeBorderRadius(10),
              ),
              color: _themeController.primaryColor200.value.withOpacity(.1),
            ),
            items: List.generate(
              _listGender.length,
              (index) => DropdownMenuItem<String>(
                value: _listGender[index],
                child: Text(_listGender[index]),
              ),
            ),
          ),
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
