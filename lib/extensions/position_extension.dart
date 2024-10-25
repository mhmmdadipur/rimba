part of 'extensions.dart';

extension PositionExtension on Position {
  LatLng get convertToLatLng => LatLng(latitude, longitude);
}
