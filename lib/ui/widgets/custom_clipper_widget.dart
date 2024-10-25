part of 'widgets.dart';

class CardClipper extends CustomClipper<Path> {
  final double distance;
  final double circleRadius;
  final bool onRight;

  CardClipper({
    required this.distance,
    required this.circleRadius,
    this.onRight = true,
  });

  @override
  bool shouldReclip(CardClipper oldClipper) => true;

  @override
  Path getClip(Size size) {
    if (onRight) {
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width - circleRadius - distance - distance, 0)
        ..quadraticBezierTo(size.width - circleRadius - distance, 0,
            size.width - circleRadius - distance, distance)
        ..quadraticBezierTo(
            size.width - circleRadius - distance,
            circleRadius + distance,
            size.width - distance,
            circleRadius + distance)
        ..quadraticBezierTo(size.width, circleRadius + distance, size.width,
            circleRadius + distance + distance)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);

      path.close();
      return path;
    } else {
      final path = Path()
        ..moveTo(size.width, 0)
        ..lineTo(0 + circleRadius + distance + distance, 0)
        ..quadraticBezierTo(0 + circleRadius + distance, 0,
            0 + circleRadius + distance, distance)
        ..quadraticBezierTo(0 + circleRadius + distance,
            circleRadius + distance, 0 + distance, circleRadius + distance)
        ..quadraticBezierTo(
            0, circleRadius + distance, 0, circleRadius + distance + distance)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);

      path.close();
      return path;
    }
  }
}

class HexagonClipper extends CustomClipper<Path> {
  HexagonClipper();

  @override
  bool shouldReclip(HexagonClipper oldClipper) => true;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * .5, 0);
    path.lineTo(size.width * .06698, size.height * .25);
    path.lineTo(size.width * .06698, size.height * .75);
    path.lineTo(size.width * .5, size.height);
    path.lineTo(size.width * .93302, size.height * .75);
    path.lineTo(size.width * .93302, size.height * .25);
    path.lineTo(size.width * .5, 0);
    path.close();

    return path;
  }
}
