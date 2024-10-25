part of 'widgets.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final List<DropdownMenuItem<T?>>? items;
  final T? value;
  final void Function(T?)? onChanged;

  /// Dropdown settings
  final void Function(bool)? onMenuStateChange;
  final bool autofocus;
  final FocusNode? focusNode;
  final AlignmentGeometry alignment;

  /// Dropdown with custom button
  final Widget? customButton;

  /// Dropdown text styling
  final TextStyle? style;

  /// Dropdown hint styling
  final Widget? hint;
  final Widget? disabledHint;
  final String hintText;
  final TextStyle? hintStyle;

  /// Dropdown button styling
  final bool isExpanded;
  final double? buttonHeight;
  final double? buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;

  /// Dropdown item styling
  final double itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final WidgetStateProperty<Color?>? itemOverlayColor;
  final List<double>? customItemHeights;

  /// Dropdown icon styling
  final IconStyleData? iconStyleData;

  /// Dropdown pop up menu styling
  final DropdownDirection dropdownDirection;
  final double? dropdownWidth;
  final double? dropdownMaxHeight;
  final Offset dropdownOffset;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;

  /// Dropdown search
  final TextEditingController? searchController;
  final SearchMatchFn? searchMatchFn;

  /// Multiple Select Items
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final bool multipleValue;
  final List<T>? values;
  final int? itemCount;
  final String Function(List<T>)? renderLabelItemBuilder;

  const CustomDropdownWidget({
    super.key,
    required this.items,
    this.value,
    this.onChanged,

    /// Dropdown settings
    this.onMenuStateChange,
    this.focusNode,
    this.autofocus = false,
    this.alignment = AlignmentDirectional.centerStart,

    /// Dropdown with custom button
    this.customButton,

    /// Dropdown text styling
    this.style,

    /// Dropdown hint styling
    this.hint,
    this.disabledHint,
    this.hintText = 'Select Item...',
    this.hintStyle,

    /// Dropdown button styling
    this.isExpanded = false,
    this.buttonHeight = 40,
    this.buttonWidth,
    this.buttonPadding = EdgeInsets.zero,
    this.buttonDecoration,

    /// Dropdown item styling
    this.itemHeight = 40,
    this.itemPadding,
    this.itemOverlayColor,
    this.customItemHeights,

    /// Dropdown icon styling
    this.iconStyleData,

    /// Dropdown pop up menu styling
    this.dropdownDirection = DropdownDirection.left,
    this.dropdownWidth,
    this.dropdownMaxHeight = 250,
    this.dropdownOffset = const Offset(0, -7.5),
    this.dropdownPadding = const EdgeInsets.only(bottom: 8),
    this.dropdownDecoration,

    /// Dropdown search
    this.searchController,
    this.searchMatchFn,

    /// Multiple Select Items
    this.selectedItemBuilder,
    this.multipleValue = false,
    this.values,
    this.itemCount,
    this.renderLabelItemBuilder,
  }) : assert(multipleValue ? values != null && itemCount != null : true);

  @override
  State<CustomDropdownWidget<T>> createState() =>
      CustomDropdownWidgetState<T>();
}

class CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton2<T?>(
          value: widget.value,
          onChanged: widget.onChanged,
          items: widget.items,

          /// Dropdown settings
          onMenuStateChange: widget.onMenuStateChange,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          alignment: widget.alignment,

          /// Dropdown with custom button
          customButton: widget.customButton,

          /// Dropdown text styling
          style: TextStyle(
                  fontFamily: 'Poppins',
                  color: _themeController.getPrimaryTextColor.value,
                  fontWeight: FontWeight.w400,
                  fontSize: 13)
              .copyWithTextStyle(widget.style),

          /// Dropdown hint styling
          hint: widget.hint ??
              Text(widget.hintText,
                  style: TextStyle(
                          fontFamily: 'Poppins',
                          color: _themeController.getSecondaryTextColor.value,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)
                      .copyWithTextStyle(widget.hintStyle)),

          /// Dropdown button styling
          isExpanded: widget.isExpanded,
          buttonStyleData: ButtonStyleData(
            elevation: 0,
            width: widget.buttonWidth,
            height: widget.buttonHeight,
            padding: widget.buttonPadding,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.2,
                  color: _themeController.getSecondaryTextColor.value
                      .withOpacity(.5)),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(10)),
            ).copyWithBoxDecoration(widget.buttonDecoration),
          ),

          /// Dropdown item styling
          menuItemStyleData: MenuItemStyleData(
            height: widget.itemHeight,
            customHeights: widget.customItemHeights,
            padding: widget.itemPadding,
            overlayColor: widget.itemOverlayColor ??
                WidgetStatePropertyAll(
                    _themeController.primaryColor200.value.withOpacity(.1)),
          ),

          /// Dropdown icon styling
          iconStyleData: widget.iconStyleData ??
              IconStyleData(
                icon: const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.arrow_right_rounded)),
                openMenuIcon: const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.arrow_drop_down_rounded)),
                iconDisabledColor: _themeController.getSecondaryTextColor.value
                    .withOpacity(.5),
                iconEnabledColor: _themeController.getPrimaryTextColor.value,
              ),

          /// Dropdown pop up menu styling
          dropdownStyleData: DropdownStyleData(
            elevation: 0,
            width: widget.dropdownWidth,
            maxHeight: widget.dropdownMaxHeight,
            offset: widget.dropdownOffset,
            direction: widget.dropdownDirection,
            padding: widget.dropdownPadding,
            decoration: BoxDecoration(
              color: _themeController.getPrimaryBackgroundColor.value,
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(5)),
              boxShadow: _themeController.getShadowProfile().copyWith([
                SharedMethod.renderBoxShadow(
                    opacity: .1, blurRadius: 20, dx: 0, dy: -2.77),
              ]),
            ).copyWithBoxDecoration(widget.dropdownDecoration),
          ),

          /// Dropdown search
          dropdownSearchData: widget.searchController == null
              ? null
              : DropdownSearchData(
                  searchInnerWidgetHeight: 40,
                  searchController: widget.searchController,
                  searchInnerWidget: renderDropdownSearch(),
                  searchMatchFn: widget.searchMatchFn ??
                      (item, searchValue) => '${item.value}'
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()),
                ),

          /// Multiple Select Items
          ///* will display widgets according to the order of the amount of data.
          ///* if the amount of data is 1 then the 1st order widget will be displayed
          ///* (index = 0).t
          selectedItemBuilder: widget.selectedItemBuilder ??
              (widget.multipleValue
                  ? (context) => List.generate(
                        widget.itemCount ?? 0,
                        (index) => Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.renderLabelItemBuilder
                                    ?.call(widget.values ?? []) ??
                                (widget.values ?? []).join(', '),
                            maxLines: 1,
                            style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: _themeController
                                        .getPrimaryTextColor.value,
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13)
                                .copyWithTextStyle(widget.style),
                          ),
                        ),
                      )
                  : widget.selectedItemBuilder),
        ),
      ),
    );
  }

  Widget renderDropdownSearch() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: _themeController.getPrimaryBackgroundColor.value,
      child: CustomTextField(
        height: 40,
        maxLines: null,
        keyboardType: TextInputType.text,
        hintText: 'Search for an item...',
        textEditingController: widget.searchController,
        padding: const EdgeInsets.only(left: 15, right: 10),
        style: TextStyle(
            fontSize: 13, color: _themeController.primaryColor200.value),
        hintStyle: TextStyle(
            fontSize: 13, color: _themeController.primaryColor200.value),
        decoration: BoxDecoration(
          color: _themeController.primaryColor200.value.withOpacity(.1),
          borderRadius:
              BorderRadius.circular(_themeController.getThemeBorderRadius(10)),
          border: Border.all(
            color: _themeController.primaryColor200.value.withOpacity(.2),
          ),
        ),
        leadingChildren: [
          Icon(IconlyLight.search,
              size: 20, color: _themeController.primaryColor200.value),
        ],
      ),
    );
  }
}

class CustomDropdownMenuItem<T> extends DropdownMenuItem<T> {
  final dynamic data;

  const CustomDropdownMenuItem({
    super.key,
    this.data,
    super.onTap,
    super.value,
    super.enabled,
    super.alignment,
    required super.child,
  });
}
