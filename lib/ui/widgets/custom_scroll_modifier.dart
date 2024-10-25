part of 'widgets.dart';

class CustomScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ScrollToHideWidget extends StatefulWidget {
  final ScrollController controller;
  final Duration duration;
  final double height;
  final Widget child;
  final bool isEnableToHide;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior = Clip.none;
  final Curve curve = Curves.linear;

  const ScrollToHideWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.height,
    this.duration = const Duration(milliseconds: 200),
    this.isEnableToHide = true,
    this.alignment = Alignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
  });

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      if (!isVisible) setState(() => isVisible = true);
    } else if (direction == ScrollDirection.reverse) {
      if (isVisible) setState(() => isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: widget.isEnableToHide
          ? isVisible
              ? widget.height
              : 0
          : widget.height,
      alignment: widget.alignment,
      padding: widget.padding,
      color: widget.color,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      width: widget.width,
      constraints: widget.constraints,
      margin: widget.margin,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      clipBehavior: widget.clipBehavior,
      curve: widget.curve,
      child: widget.child,
    );
  }
}

class IdleToShowWidget extends StatefulWidget {
  final ScrollController controller;
  final Duration duration;
  final double height;
  final Widget child;
  final bool isEnableToHide;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior = Clip.none;
  final Curve curve = Curves.linear;

  const IdleToShowWidget({
    super.key,
    required this.child,
    required this.controller,
    required this.height,
    this.duration = const Duration(milliseconds: 200),
    this.isEnableToHide = true,
    this.alignment = Alignment.center,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
  });

  @override
  State<IdleToShowWidget> createState() => _IdleToShowWidgetState();
}

class _IdleToShowWidgetState extends State<IdleToShowWidget> {
  bool isVisible = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward ||
        direction == ScrollDirection.reverse) {
      if (isVisible) setState(() => isVisible = false);
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (!isVisible) setState(() => isVisible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: widget.isEnableToHide
          ? isVisible
              ? widget.height
              : 0
          : widget.height,
      alignment: widget.alignment,
      padding: widget.padding,
      color: widget.color,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      width: widget.width,
      constraints: widget.constraints,
      margin: widget.margin,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      clipBehavior: widget.clipBehavior,
      curve: widget.curve,
      child: widget.child,
    );
  }
}
