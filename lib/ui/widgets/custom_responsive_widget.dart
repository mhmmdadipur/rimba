part of 'widgets.dart';

class CustomResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const CustomResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 815;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 815 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static dynamic value(
    BuildContext context, {
    required dynamic whenMobile,
    required dynamic whenDesktop,
    whenTablet,
  }) {
    if (MediaQuery.of(context).size.width >= 1200) {
      return whenDesktop;
    } else if (MediaQuery.of(context).size.width >= 815 && whenTablet != null) {
      return whenTablet!;
    } else {
      return whenMobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 1200) {
      return desktop;
    } else if (size.width >= 815 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

class CustomResponsiveConstrainedLayout extends StatelessWidget {
  final Widget child;

  const CustomResponsiveConstrainedLayout({
    super.key,
    required this.child,
  });

  static double getMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 1500) {
      return 1300;
    } else if (width >= 1300) {
      return 1100;
    } else if (width >= 1100) {
      return 900;
    } else if (width >= 815) {
      return 1200;
    } else {
      return double.infinity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: getMaxWidth(context)),
        child: child,
      ),
    );
  }
}

class ItemResponsiveLayout {
  final int flex;
  final bool isExpanded;
  final Widget child;

  ItemResponsiveLayout({
    this.flex = 1,
    this.isExpanded = true,
    required this.child,
  });
}

class CustomResponsiveLayout extends StatelessWidget {
  final bool fixedRow;
  final double separatorSize;
  final CrossAxisAlignment crossAxisAlignment;
  final List<ItemResponsiveLayout> children;

  const CustomResponsiveLayout({
    super.key,
    this.fixedRow = false,
    this.separatorSize = SharedValue.defaultPadding,
    this.children = const <ItemResponsiveLayout>[],
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    assert(children.length <= 2);

    int length = children.length * 2 - 1;

    if (fixedRow) {
      return PaddingRow(
        crossAxisAlignment: crossAxisAlignment,
        padding: EdgeInsets.only(bottom: separatorSize),
        children: List.generate(
          length,
          (index) {
            final int itemIndex = index ~/ 2;

            if (index.isEven) {
              int flex = children[itemIndex].flex;
              Widget child = children[itemIndex].child;

              return children[itemIndex].isExpanded
                  ? Expanded(flex: flex, child: child)
                  : Flexible(flex: flex, child: child);
            } else {
              return SizedBox(width: separatorSize);
            }
          },
        ),
      );
    } else {
      return CustomResponsiveWidget(
        mobile: PaddingColumn(
          crossAxisAlignment: crossAxisAlignment,
          padding: EdgeInsets.only(bottom: separatorSize),
          children: List.generate(
            length,
            (index) {
              final int itemIndex = index ~/ 2;

              if (index.isEven) {
                return children[itemIndex].child;
              } else {
                return SizedBox(height: separatorSize);
              }
            },
          ),
        ),
        tablet: PaddingRow(
          crossAxisAlignment: crossAxisAlignment,
          padding: EdgeInsets.only(bottom: separatorSize),
          children: List.generate(
            length,
            (index) {
              final int itemIndex = index ~/ 2;

              if (index.isEven) {
                int flex = children[itemIndex].flex;
                Widget child = children[itemIndex].child;

                return children[itemIndex].isExpanded
                    ? Expanded(flex: flex, child: child)
                    : Flexible(flex: flex, child: child);
              } else {
                return SizedBox(width: separatorSize);
              }
            },
          ),
        ),
        desktop: PaddingRow(
          crossAxisAlignment: crossAxisAlignment,
          padding: EdgeInsets.only(bottom: separatorSize),
          children: List.generate(
            length,
            (index) {
              final int itemIndex = index ~/ 2;

              if (index.isEven) {
                int flex = children[itemIndex].flex;
                Widget child = children[itemIndex].child;

                return children[itemIndex].isExpanded
                    ? Expanded(flex: flex, child: child)
                    : Flexible(flex: flex, child: child);
              } else {
                return SizedBox(width: separatorSize);
              }
            },
          ),
        ),
      );
    }
  }
}
