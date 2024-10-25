part of 'extensions.dart';

extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
