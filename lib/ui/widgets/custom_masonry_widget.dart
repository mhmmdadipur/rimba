part of 'widgets.dart';

class CustomMasonryWidget extends StatefulWidget {
  final double widthCard;
  final double heightCard;
  final double iconSize;
  final int mainAxisCount;
  final int crossAxisCount;
  final List<CustomItemMenu> itemMenus;

  const CustomMasonryWidget({
    super.key,
    this.iconSize = 24,
    this.widthCard = 50,
    this.heightCard = 50,
    this.mainAxisCount = 1,
    this.crossAxisCount = 4,
    required this.itemMenus,
  });

  @override
  State<CustomMasonryWidget> createState() => _CustomMasonryWidgetState();
}

class _CustomMasonryWidgetState extends State<CustomMasonryWidget> {
  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void actionModalButton() {
    SharedWidget.renderDefaultBottomModal(
      titleText: 'All Menus',
      subtitle: 'Menu Available in The App',
      content: [
        Expanded(
          child: GridView.builder(
            itemCount: widget.itemMenus.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 95,
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: SharedValue.defaultPadding,
              crossAxisSpacing: SharedValue.defaultPadding,
            ),
            itemBuilder: (context, index) =>
                Obx(() => renderMenuCard(widget.itemMenus[index])),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    /// To find out fix length of grid view
    int crossAxisCount = CustomResponsiveWidget.value(context,
        whenMobile: widget.crossAxisCount,
        whenTablet: widget.crossAxisCount + 1,
        whenDesktop: widget.crossAxisCount + 2);

    /// To find out total of items is display in grid view
    int totalCount = crossAxisCount * widget.mainAxisCount;

    /// To find out total of items menus is bigger than total count,
    /// is used to render "Other" menu.
    bool isExceed = widget.itemMenus.length > totalCount;

    /// The [isExceed] is true, then render "Other" menu
    int length = isExceed ? totalCount : widget.itemMenus.length;

    return GridView.builder(
      itemCount: length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 95,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: SharedValue.defaultPadding,
        crossAxisSpacing: SharedValue.defaultPadding,
      ),
      itemBuilder: (context, index) => isExceed && index == totalCount - 1
          ? renderMenuCard(CustomItemMenu(
              name: 'Other',
              icon: Iconsax.element_plus,
              color: _themeController.secondaryColor100.value,
              onTap: actionModalButton))
          : Obx(() => renderMenuCard(widget.itemMenus[index])),
    );
  }

  Widget renderMenuCard(CustomItemMenu customItemMenu) {
    return InkWell(
      onTap: customItemMenu.onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          Badge(
            isLabelVisible: customItemMenu.badge != null,
            backgroundColor: Colors.red.shade700,
            label: Text(SharedMethod.valuePrettier(customItemMenu.badge)),
            textStyle: const TextStyle(color: Colors.white, fontSize: 10),
            child: Container(
              width: widget.widthCard,
              height: widget.heightCard,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(15)),
                color: _themeController.getSecondaryBackgroundColor.value,
                boxShadow: _themeController.getShadowProfile(mode: 2),
              ),
              child: customItemMenu.svgAsset != null
                  ? SvgPicture.asset(
                      customItemMenu.svgAsset ?? '',
                      width: customItemMenu.iconSize ?? widget.iconSize,
                      height: customItemMenu.iconSize ?? widget.iconSize,
                      colorFilter: customItemMenu.color == null
                          ? null
                          : ColorFilter.mode(
                              customItemMenu.color ?? Colors.transparent,
                              BlendMode.srcIn),
                    )
                  : Icon(customItemMenu.icon,
                      color: customItemMenu.color,
                      size: customItemMenu.iconSize ?? widget.iconSize),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(customItemMenu.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _themeController.getSecondaryTextColor.value)),
          ),
        ],
      ),
    );
  }
}
