part of 'extensions.dart';

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  TimeOfDay toTimeOfDay() => TimeOfDay(
      hour: int.parse(split(":")[0]), minute: int.parse(split(":")[1]));

  String convertToArabicNumber() {
    String res = '';

    final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (var element in characters) {
      int? number = int.tryParse(element);
      if (number != null) {
        res += arabics[number];
      } else {
        res += element;
      }
    }

    return res;
  }
}
