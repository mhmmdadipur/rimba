import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../controllers/controllers.dart';
import '../widgets/widgets.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final ThemeController _themeController = Get.find();

  QRViewController? _qrViewController;

  static final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            cameraFacing: CameraFacing.back,
            overlay: QrScannerOverlayShape(
              borderWidth: 12,
              borderRadius: 15,
              cutOutWidth: Get.width * .8,
              cutOutHeight: Get.width * .8,
              cutOutBottomOffset: 100,
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
                    Get.back(result: event.code);
                  } else {
                    await controller.resumeCamera();
                  }
                },
              );
            },
          ),
          const CustomAppBarWidget(
              titleText: 'QR Code Scanner',
              componentColor: Colors.white,
              backgroundColor: Colors.transparent),
          Align(
            alignment: Alignment.bottomCenter,
            child: PaddingRow(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              children: [
                CustomButton(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                  onTap: () => _qrViewController?.toggleFlash(),
                  borderRadius: BorderRadius.circular(120),
                  child: Icon(MdiIcons.flashlight,
                      color: _themeController.primaryColor300.value),
                ),
                const Spacer(),
                // CustomButton(
                //   width: 60,
                //   height: 60,
                //   color: Colors.white,
                //   onTap: () => _qrViewController?.toggleFlash(),
                //   borderRadius: BorderRadius.circular(120),
                //   child: Icon(MdiIcons.image,
                //       color: _themeController.primaryColor300.value),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
