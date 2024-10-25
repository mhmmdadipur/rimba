import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/controllers.dart';
import '../../shared/shared.dart';

class QRCodeViewerPage extends StatefulWidget {
  final String data;
  final String? description;
  const QRCodeViewerPage({super.key, required this.data, this.description});

  @override
  State<QRCodeViewerPage> createState() => _QRCodeViewerPageState();
}

class _QRCodeViewerPageState extends State<QRCodeViewerPage> {
  final ThemeController _themeController = Get.find();

  late double distance = Get.height * .225, holeRadius = 45;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _themeController.primaryColor100.value,
                _themeController.primaryColor200.value,
                _themeController.primaryColor300.value,
              ]),
        ),
        child: SafeArea(
          child: ClipPath(
            clipper: TicketClipper(distance: distance, holeRadius: holeRadius),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                      _themeController.getThemeBorderRadius(28))),
                  color: SharedValue.backgroundLightColor100),
              child: Column(
                children: [
                  generateTop(),
                  DashDivider(
                      color: _themeController.getPrimaryTextColor.value
                          .withOpacity(.3),
                      height: 1.5),
                  generateBottom()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateBottom() {
    return Container(
      height: distance + holeRadius / 2,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 17),
      child: Column(
        children: [
          Text(widget.data,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(SharedMethod.valuePrettier(widget.description),
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: Get.height * .06),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(SharedValue.appName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  Text('by ${SharedValue.creatorName}'),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget generateTop() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(12),
                highlightColor:
                    _themeController.primaryColor200.value.withOpacity(.1),
                splashColor:
                    _themeController.primaryColor200.value.withOpacity(.2),
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: SharedValue.textLightColor100.withOpacity(.3),
                      borderRadius: BorderRadius.circular(
                          _themeController.getThemeBorderRadius(12))),
                  child: const Icon(EvaIcons.arrowIosBack),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'QR Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            const Text(
              'arahkan qr ini ke tempat pemindaian',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: QrImageView(data: widget.data, version: QrVersions.auto),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double distance;
  final double holeRadius;

  TicketClipper({required this.distance, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - distance - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - distance),
        clockwise: true,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - distance)
      ..arcToPoint(
        Offset(size.width, size.height - distance - holeRadius),
        clockwise: true,
        radius: const Radius.circular(1),
      );

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TicketClipper oldClipper) => true;
}

class DashDivider extends StatelessWidget {
  const DashDivider({super.key, this.height = 1, this.color = Colors.black});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
