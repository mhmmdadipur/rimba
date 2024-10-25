part of 'widgets.dart';

class PaddingColumn extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;

  const PaddingColumn({
    super.key,
    this.padding =
        const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.children = const <Widget>[],
  });

  @override
  State<PaddingColumn> createState() => _PaddingColumnState();
}

class _PaddingColumnState extends State<PaddingColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        textBaseline: widget.textBaseline,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: widget.children,
      ),
    );
  }
}

class PaddingRow extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;

  const PaddingRow({
    super.key,
    this.padding =
        const EdgeInsets.symmetric(horizontal: SharedValue.defaultPadding),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.children = const <Widget>[],
  });

  @override
  State<PaddingRow> createState() => _PaddingRowState();
}

class _PaddingRowState extends State<PaddingRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        textBaseline: widget.textBaseline,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: widget.children,
      ),
    );
  }
}
