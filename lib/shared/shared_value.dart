part of 'shared.dart';

class SharedValue {
  static const String company = "Rimba";
  static const String appType = "App";
  static const String appName = "$company $appType";
  static const String creatorName = "Mhmmd.adipur";

  // static const String baseUrl = "http://10.0.2.2:3000";
  static const String baseUrl = "https://opposite-striped-makemake.glitch.me";

  static const String passDebugMode = "tahugoreng";

  static const Color textLightColor100 = Color(0xff797979);
  static const Color textLightColor200 = Color(0xff212332);
  static const Color textLightColor300 = Color(0xff333333);
  static const Color backgroundLightColor100 = Color(0xffFFFFFF);
  static const Color backgroundLightColor200 = Color(0xffF2F5FC);
  static const Color backgroundLightColor300 = Color(0xffF4F6F9);

  static const Color textDarkColor100 = Color(0xffDADADA);
  static const Color textDarkColor200 = Color(0xffF2F5FC);
  static const Color textDarkColor300 = Color(0xffF4F6F9);
  static const Color backgroundDarkColor100 = Color(0xFF2b2d3c);
  static const Color backgroundDarkColor200 = Color(0xFF212332);
  static const Color backgroundDarkColor300 = Color(0xFF1c1d27);

  static const Color errorColor = Color(0xffFA7070);
  static const Color successColor = Color(0xff4ECCA3);
  static const Color warningColor = Color(0xffFFEBAD);

  static const String defaultImage = 'https://picsum.photos/id/1005/1921/1281';
  static const double defaultPadding = 14;

  static const Map<String, String> defaultHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
}
