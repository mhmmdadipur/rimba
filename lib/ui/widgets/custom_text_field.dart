part of 'widgets.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final double? height;
  final double? width;
  final bool? enable;
  final bool? autofocus;
  final bool obscureText;
  final bool useScan;
  final bool useBatchScan;
  final bool showClearButton;
  final bool isRequired;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? paddingTitle;
  final EdgeInsetsGeometry? marginTitle;
  final EdgeInsetsGeometry? contentPadding;
  final Decoration? decoration;
  final String? hintText;
  final String? title;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onCapture;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onClear;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final List<Widget> leadingChildren;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    this.textEditingController,
    this.height = 40,
    this.width,
    this.decoration,
    this.onTap,
    this.hintText,
    this.padding,
    this.paddingTitle,
    this.contentPadding = EdgeInsets.zero,
    this.margin,
    this.marginTitle,
    this.prefixIcon,
    this.onChanged,
    this.onClear,
    this.textCapitalization = TextCapitalization.none,
    this.onCapture,
    this.inputFormatters,
    this.keyboardType,
    this.enable = true,
    this.useScan = false,
    this.useBatchScan = false,
    this.obscureText = false,
    this.showClearButton = false,
    this.textInputAction,
    this.maxLength,
    this.onSubmitted,
    this.style,
    this.leadingChildren = const [],
    this.autofocus,
    this.hintStyle,
    this.maxLines = 1,
    this.focusNode,
    this.title,
    this.titleStyle,
    this.isRequired = false,
    this.textAlign = TextAlign.start,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final ThemeController _themeController = Get.find();

  late TextEditingController _textController;
  QRViewController? _qrViewController;

  final Rx<bool> _isEmpty = Rx<bool>(true);
  final Rx<bool> _isBatchScan = Rx<bool>(false);
  final Rx<bool> _obscurePassword = Rx<bool>(true);

  static final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _textController = widget.textEditingController ?? TextEditingController();
    _isEmpty(_textController.text.trim().isEmpty);
    _textController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(onTextChanged);
    // _textController.dispose();
    _qrViewController?.dispose();
    super.dispose();
  }

  void onTextChanged() => _isEmpty(_textController.text.trim().isEmpty);

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: widget.padding,
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      child: Row(
        crossAxisAlignment: (widget.maxLines ?? 0) > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: widget.prefixIcon != null,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: widget.prefixIcon),
          ),
          Expanded(
            child: Obx(
              () => TextField(
                controller: _textController,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                focusNode: widget.focusNode,
                textCapitalization: widget.textCapitalization,
                enabled: widget.enable,
                autofocus: widget.autofocus ?? false,
                textAlign: widget.textAlign,
                style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _themeController.getPrimaryTextColor.value)
                    .copyWithTextStyle(widget.style),
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.keyboardType,
                cursorColor: _themeController.isDarkMode.value
                    ? SharedValue.textDarkColor200
                    : _themeController.primaryColor200.value,
                onTap: widget.onTap,
                onChanged: (value) {
                  _isEmpty(value.trim().isEmpty);
                  if (widget.onChanged != null) widget.onChanged!(value);
                },
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                obscureText:
                    widget.obscureText ? _obscurePassword.value : false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  contentPadding: widget.contentPadding,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: _themeController.getSecondaryTextColor.value,
                  ).copyWithTextStyle(widget.hintStyle),
                  suffixIcon: widget.obscureText
                      ? GestureDetector(
                          onTap: () =>
                              _obscurePassword(!_obscurePassword.value),
                          child: Icon(IconlyBroken.show,
                              color: _obscurePassword.value
                                  ? _themeController.getPrimaryTextColor.value
                                  : Colors.grey.withOpacity(.4)),
                        )
                      : null,
                ),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: !_isEmpty.value && widget.showClearButton,
              child: CustomButton(
                width: 48,
                padding: EdgeInsets.zero,
                color: Colors.transparent,
                child: const Icon(EvaIcons.closeCircle,
                    size: 20, color: Colors.red),
                onTap: () {
                  _isEmpty(true);
                  _textController.clear();
                  if (widget.onClear != null) widget.onClear!();
                },
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: widget.useScan,
              child: CustomButton(
                width: 48,
                onTap: actionScanButton,
                padding: EdgeInsets.zero,
                color: Colors.transparent,
                child: Icon(MdiIcons.barcodeScan,
                    color: _themeController.getPrimaryTextColor.value,
                    size: 22),
              ),
            ),
          )
        ].copyWith(widget.leadingChildren),
      ),
    );

    if (widget.title == null && !widget.useScan) return child;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: widget.title != null,
            child: Container(
                padding: widget.paddingTitle,
                margin: widget.marginTitle,
                child: renderTitle())),
        Visibility(
            visible: widget.title != null, child: const SizedBox(height: 5.0)),
        child,
        Visibility(
            visible: widget.useScan && widget.useBatchScan,
            child: const SizedBox(height: 5.0)),
        Visibility(
          visible: widget.useScan && widget.useBatchScan,
          child: Container(
            padding: widget.padding,
            margin: widget.margin,
            child: Row(
              children: [
                const Expanded(
                  child: Text('Use batch scan', style: TextStyle(fontSize: 12)),
                ),
                Obx(
                  () => SizedBox(
                    height: 30,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch.adaptive(
                        value: _isBatchScan.value,
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return _themeController.primaryColor200.value;
                          }
                          return Colors.red;
                        }),
                        activeColor: _themeController.primaryColor200.value,
                        inactiveTrackColor: Colors.red.withOpacity(.3),
                        onChanged: (value) => _isBatchScan(!_isBatchScan.value),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void actionScanButton() async {
    FocusManager.instance.primaryFocus!.unfocus();
    var status = await Permission.camera.request();
    if (status.isGranted) {
      SharedWidget.renderDefaultBottomModal(
        titleText: 'Scan QR Code',
        subtitle:
            'You can use QR Code scanning\nto enter a QR code into the text field',
        isScrollControlled: true,
        content: [
          const SizedBox(height: 25),
          SizedBox(
            height: Get.height * .6,
            child: QRView(
              cameraFacing: CameraFacing.back,
              overlay: QrScannerOverlayShape(
                borderWidth: 12,
                borderRadius: 15,
                borderColor: _themeController.primaryColor200.value,
              ),
              key: _qrKey,
              onQRViewCreated: (QRViewController controller) {
                _qrViewController = controller;
                if (_isBatchScan.value) {
                  controller.scannedDataStream.listen(
                    (event) async {
                      await controller.pauseCamera();
                      await Future.delayed(const Duration(seconds: 1));
                      debugPrint('Scanner: ${event.code}');
                      if (event.code != null) {
                        if (widget.onCapture != null) {
                          widget.onCapture!(event.code!);
                        }
                        await controller.resumeCamera();
                      }
                    },
                  );
                } else {
                  controller.scannedDataStream.listen(
                    (event) async {
                      await controller.pauseCamera();
                      debugPrint('Scanner: ${event.code}');
                      if (event.code != null) {
                        _textController.text = event.code!;
                        _isEmpty(_textController.text.trim().isNotEmpty);
                        Get.back();
                        if (widget.onCapture != null) {
                          widget.onCapture!(event.code!);
                        }
                      }
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            height: 40,
            label: 'Close Scanner',
            color: Colors.red,
            width: Get.width * .7,
            padding: EdgeInsets.zero,
            onTap: () => Get.back(),
          ),
          const SizedBox(height: 50),
        ],
      );
    }
  }

  Widget renderTitle() {
    return Row(
      children: [
        Text(
          widget.title ?? '',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _themeController.getSecondaryTextColor.value,
          ).copyWithTextStyle(widget.titleStyle),
        ),
        Visibility(
          visible: widget.isRequired,
          child: Text(
            ' *',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ).copyWithTextStyle(widget.titleStyle),
          ),
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final double height;
  final double width;
  final bool? enable;
  final bool? autofocus;
  final bool obscureText;
  final bool useScan;
  final bool showClearButton;
  final bool isRequired;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final String? hintText;
  final String? title;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCapture;
  final GestureTapCallback? onClear;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final List<Widget> suffixChildren;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final Color? color;
  final BorderRadius? borderRadius;

  const CustomTextFormField({
    super.key,
    this.textEditingController,
    this.height = 40,
    this.width = double.infinity,
    this.hintText,
    this.contentPadding = EdgeInsets.zero,
    this.margin,
    this.prefixIcon,
    this.onChanged,
    this.onClear,
    this.onCapture,
    this.inputFormatters,
    this.keyboardType,
    this.enable = true,
    this.useScan = false,
    this.obscureText = false,
    this.showClearButton = false,
    this.textInputAction,
    this.maxLength,
    this.style,
    this.suffixChildren = const [],
    this.autofocus,
    this.hintStyle,
    this.maxLines = 1,
    this.focusNode,
    this.title,
    this.isRequired = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.color,
    this.borderRadius,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final ThemeController _themeController = Get.find();

  late TextEditingController _textController;
  QRViewController? _qrViewController;

  final Rx<String?> _errortext = Rx<String?>(null);
  final Rx<bool> _isValidate = Rx<bool>(true);
  final Rx<bool> _isEmpty = Rx<bool>(true);
  final Rx<bool> _isOnFocus = Rx<bool>(false);
  final Rx<bool> _obscurePassword = Rx<bool>(true);

  static final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = widget.textEditingController ?? TextEditingController();
    _isEmpty(_textController.text.trim().isEmpty);
    _textController.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _qrViewController?.dispose();
    super.dispose();
  }

  void _onTextChanged() => _isEmpty(_textController.text.trim().isEmpty);

  void _onFocusChange() => _isOnFocus(_focusNode.hasFocus);

  void actionClearButton() {
    _isEmpty(true);
    _textController.clear();
    if (widget.onClear != null) widget.onClear!();
    if (widget.onChanged != null) {
      widget.onChanged!(_textController.text);
    }
    if (widget.validator != null) {
      _errortext.update(
          (val) => _errortext.value = widget.validator!(_textController.text));
      _isValidate(_errortext.value == null);
    }
  }

  void actionScanButton() async {
    FocusManager.instance.primaryFocus!.unfocus();
    var status = await Permission.camera.request();
    if (status.isGranted) {
      SharedWidget.renderDefaultBottomModal(
        titleText: 'Scan QR Code',
        subtitle:
            'You can use QR Code scanning\nto enter a QR code into the text field',
        isScrollControlled: true,
        content: [
          const SizedBox(height: 25),
          SizedBox(
            height: Get.height * .6,
            child: QRView(
              cameraFacing: CameraFacing.back,
              overlay: QrScannerOverlayShape(
                borderWidth: 12,
                borderRadius: 15,
                borderColor: _themeController.primaryColor200.value,
              ),
              key: _qrKey,
              onQRViewCreated: (QRViewController controller) {
                _qrViewController = controller;
                controller.scannedDataStream.listen(
                  (event) async {
                    await controller.pauseCamera();
                    debugPrint('Scanner: ${event.code}');
                    if (event.code != null) {
                      _textController.text = event.code!;
                      _isEmpty(_textController.text.trim().isNotEmpty);
                      Get.back();
                      if (widget.onCapture != null) {
                        widget.onCapture!(event.code!);
                      }
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 25),
          CustomButton(
            height: 40,
            label: 'Close Scanner',
            color: Colors.red,
            width: Get.width * .7,
            padding: EdgeInsets.zero,
            onTap: () => Get.back(),
          ),
          const SizedBox(height: 50),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color color = widget.color ?? _themeController.primaryColor200.value;

      return Container(
        margin: widget.margin,
        child: TextFormField(
          focusNode: _focusNode,
          enabled: widget.enable,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          controller: _textController,
          autofocus: widget.autofocus ?? false,
          autovalidateMode: widget.autovalidateMode,
          textInputAction: widget.textInputAction,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          cursorColor: _themeController.isDarkMode.value
              ? SharedValue.textDarkColor200
              : _themeController.primaryColor200.value,
          obscureText: widget.obscureText ? _obscurePassword.value : false,
          style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _themeController.getPrimaryTextColor.value)
              .copyWithTextStyle(widget.style),
          validator: (value) {
            if (widget.validator != null) {
              _errortext
                  .update((val) => _errortext.value = widget.validator!(value));
              _isValidate(_errortext.value == null);
            }
            return _errortext.value;
          },
          onChanged: (value) {
            _isEmpty(value.trim().isEmpty);
            if (widget.onChanged != null) widget.onChanged!(value);
            if (widget.validator != null) {
              _errortext
                  .update((val) => _errortext.value = widget.validator!(value));
              _isValidate(_errortext.value == null);
            }
          },
          decoration: InputDecoration(
            contentPadding: widget.contentPadding,
            constraints: BoxConstraints(
              maxWidth: widget.width,
              maxHeight: _isValidate.value ? widget.height : widget.height + 24,
            ),
            filled: true,
            fillColor: (_isValidate.value ? color : Colors.red).withOpacity(.1),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)
                .copyWithTextStyle(widget.hintStyle),
            label: Visibility(
              visible: widget.title != null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _isValidate.value ? color : Colors.red,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isRequired,
                    child: const Text('*',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.red,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: Visibility(
              visible: widget.prefixIcon != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: widget.prefixIcon,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: PaddingRow(
              padding: EdgeInsets.zero,
              mainAxisSize: MainAxisSize.min,
              children: widget.suffixChildren.copyWith([
                Visibility(
                  visible: !_isEmpty.value && widget.showClearButton,
                  child: CustomButton(
                    width: 48,
                    onTap: actionClearButton,
                    padding: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: const Icon(EvaIcons.closeCircle,
                        size: 20, color: Colors.red),
                  ),
                ),
                Visibility(
                  visible: widget.useScan,
                  child: CustomButton(
                    width: 48,
                    onTap: actionScanButton,
                    padding: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: Icon(MdiIcons.barcodeScan,
                        color: _themeController.getPrimaryTextColor.value,
                        size: 22),
                  ),
                ),
                Visibility(
                  visible: widget.obscureText,
                  child: CustomButton(
                    width: 48,
                    onTap: () => _obscurePassword(!_obscurePassword.value),
                    padding: EdgeInsets.zero,
                    color: Colors.transparent,
                    child: Icon(IconlyBroken.show,
                        color: _obscurePassword.value
                            ? _themeController.getPrimaryTextColor.value
                            : Colors.grey.withOpacity(.4),
                        size: 22),
                  ),
                ),
              ]),
            ),
            errorStyle: const TextStyle(fontSize: 12),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: color),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                        _themeController.getThemeBorderRadius(30))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: color),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                        _themeController.getThemeBorderRadius(30))),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1.5, color: Colors.red),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                        _themeController.getThemeBorderRadius(30))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.red),
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                        _themeController.getThemeBorderRadius(30))),
          ),
        ),
      );
    });
  }
}
