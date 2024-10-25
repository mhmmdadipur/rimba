import 'package:flutter/material.dart';

enum NextStatusType { button, label }

class CustomStatus {
  ///menunjukan detail status ini
  final int? idStatus;
  final String labelStatus;
  final Color? colorStatus;
  final String? descriptionStatus;

  ///menunjukan apakah status ini selesai/terakhir
  final bool isStatusDone;

  ///menunjukan status selanjutnya
  final NextStatusType nextStatusType;
  final String? nextStatusLabel;
  final dynamic nextStatusData;

  ///jika tidak [Null] dapat reject status
  final String? rejectedLabel;

  CustomStatus({
    this.idStatus,
    required this.labelStatus,
    this.colorStatus,
    this.descriptionStatus,
    this.isStatusDone = false,
    this.nextStatusType = NextStatusType.label,
    this.nextStatusData,
    this.nextStatusLabel,
    this.rejectedLabel,
  });

  @override
  int get hashCode => Object.hash(idStatus, labelStatus);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return (other is CustomStatus &&
        other.runtimeType == runtimeType &&
        other.labelStatus == labelStatus &&
        other.idStatus == idStatus);
  }
}
