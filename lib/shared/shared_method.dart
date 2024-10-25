part of 'shared.dart';

class SharedMethod {
  static final ThemeController _themeController = Get.find();
  static final ThemeData theme = Theme.of(Get.context!);

  static Future<void> urlLauncher(
    String url,
  ) async {
    if (!await launchUrl(Uri.parse(url))) {
      SharedWidget.renderDefaultSnackBar(message: 'Could not launch $url');
    }
  }

  static void copyToClipboard(
    String value,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));

    Get.rawSnackbar(
        icon: const Icon(EvaIcons.checkmarkCircle, color: Colors.white),
        message: 'Successfully copied',
        barBlur: 0,
        margin: const EdgeInsets.only(bottom: 10),
        maxWidth: 300,
        borderRadius: _themeController.getThemeBorderRadius(50),
        backgroundColor: _themeController.primaryColor200.value);
  }

  static String valuePrettier(
    dynamic value, {
    String replace = '...',
  }) {
    String? temp;

    if (value == null || value == 'null') return replace;

    if (value is String) {
      if (value.isEmpty) return replace;
    }

    if (value is List) temp = value.join(', ');

    return temp ?? '$value';
  }

  static String formatValueToDecimal(
    dynamic number, {
    String replace = '...',
  }) {
    if (number == null || number == 'null') return replace;

    final decimalPattern = NumberFormat.decimalPattern();

    int? res;
    if (number is num) {
      res = number.toInt();
    } else {
      res = int.tryParse(number);
    }
    if (res == null) return replace;

    return decimalPattern.format(res);
  }

  static String formatValueToCurrency(
    dynamic number, {
    int? decimalDigits = 2,
    String replace = '...',
  }) {
    if (number == null || number == 'null') return replace;

    int? res;
    if (number is num) {
      res = number.toInt();
    } else {
      res = int.tryParse(number);
    }
    if (res == null) return '-';
    return NumberFormat.currency(
            locale: 'id', symbol: 'Rp ', decimalDigits: decimalDigits)
        .format(res);
  }

  static String formatValueToDate(
    dynamic value, {
    String? newPattern,
    String replace = '...',
    bool convertToLocal = false,
  }) {
    if (value == null || value == 'null') return replace;

    DateTime? res = DateTime.tryParse(value.toString());

    if (res == null) return replace;

    return DateFormat(newPattern ?? 'HH:mm, dd/MM/yyyy')
        .format(convertToLocal ? res.toLocal() : res);
  }

  static Future<File> compressImage({
    required File file,
    int? quality,
  }) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: quality ?? 50);

    debugPrint(
        'Success: ${file.lengthSync() / 1000} Kb => ${compressedFile.lengthSync() / 1000} Kb');

    return compressedFile;
  }

  static Future<File?> compressVideo({
    required File file,
    VideoQuality quality = VideoQuality.DefaultQuality,
  }) async {
    MediaInfo? compressedVideo = await VideoCompress.compressVideo(file.path,
        quality: quality, deleteOrigin: false);

    debugPrint(
        'Success: ${file.lengthSync() / 1000} Kb => ${(compressedVideo?.filesize ?? 0) / 1000} Kb');

    return compressedVideo?.file;
  }

  static String getGreetings() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Pagi';
    } else if (hour < 18) {
      return 'Siang';
    } else if (hour < 21) {
      return 'Sore';
    } else {
      return 'Malam';
    }
  }

  static BoxShadow renderBoxShadow({
    Color color = Colors.black,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    double dx = 0,
    double dy = 0,
    double? opacity,
  }) {
    if (opacity != null) {
      assert(opacity >= 0.0 && opacity <= 1.0);
      color = color.withOpacity(opacity);
    }
    return BoxShadow(
        color: color,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        offset: Offset(dx, dy));
  }
}
