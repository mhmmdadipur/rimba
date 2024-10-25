import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../maintenance_page.dart';

class AccountJobInformationSection extends StatefulWidget {
  const AccountJobInformationSection({
    super.key,
    required this.pageController,
    required this.selectedPage,
  });

  final PageController pageController;
  final Rx<int> selectedPage;

  @override
  State<AccountJobInformationSection> createState() =>
      _AccountJobInformationSectionState();
}

class _AccountJobInformationSectionState
    extends State<AccountJobInformationSection> {
  @override
  Widget build(BuildContext context) {
    return const MaintenancePage(showBackButton: false);
  }
}
