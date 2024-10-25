import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

import '../../shared/shared.dart';
import '../widgets/widgets.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(canReturn: widget.showBackButton),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Expanded(
              flex: 7,
              child: Lottie.asset('assets/animations/under-maintenance.json',
                  width: Get.width * .7),
            ),
            const Spacer(flex: 1),
            const Text('Under Maintenance',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                  'Sorry this page is currently under maintenance,\nplease contact the admin for further clarity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14)),
            ),
            Spacer(flex: widget.showBackButton ? 1 : 2),
            Visibility(
              visible: widget.showBackButton,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: CustomButton(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  color: SharedValue.errorColor,
                  onTap: () => Get.back(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconlyBold.home, size: 18, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Back to the previous page',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
