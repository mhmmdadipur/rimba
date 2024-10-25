import 'package:flutter/material.dart';

import 'custom_data_user.dart';

class CustomItemDrawer {
  final String? label;
  final List<GroupRole> accessList;

  CustomItemDrawer({
    this.label,
    this.accessList = const [
      GroupRole.admin,
      GroupRole.employee,
      GroupRole.anonymous,
    ],
  });
}

class CustomItemDrawerDivider extends CustomItemDrawer {
  final Color? color;

  CustomItemDrawerDivider({
    this.color,
    super.accessList,
  });
}
