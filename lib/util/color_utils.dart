import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ColorUtils {
//  static const Color darkColor = ;

  static Color backgroudColor(BuildContext context){
    return Theme.of(context).scaffoldBackgroundColor;
//    return Theme.of(context).brightness == Brightness.light ? Colors.white : const Color.fromARGB(255, 21, 21, 23);
  }

  static Color inputBgColor(BuildContext context){
    return Theme.of(context).brightness == Brightness.light ? Colors.white : const Color.fromARGB(255, 21, 21, 23);
  }

  static Widget backgroundColor(BuildContext context, Widget widget){
    return  Container(
      color: ColorUtils.backgroudColor(context),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: widget,
    );
//  return Container(child: widget,);
  }

  static bool isLightColor(Color color) {
    double darkness = 1 - (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    if (darkness < 0.5) {
      return true; // It's a light color
    } else {
      return false; // It's a dark color
    }
  }

  static Color hexToColor(String code) {
    if (code == null || code.isEmpty) {
      return Colors.transparent;
    }
    return  Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static CupertionSwitchColor(BuildContext context) {
    return CupertinoTheme.of(context).brightness == Brightness.light
        ? CupertinoColors.activeGreen
        : Colors.orange;
  }

//   static Color dividerColor = Color(0xFFe2e5e7);


  static getSubtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black54
        : Colors.white70;
  }

  static textfieldColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(255, 240, 240, 240)
        : Colors.black26;
  }

  static Color pressColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color.fromARGB(255, 217, 216, 217)
        : Colors.black26;
  }
}

class ColorEntity {
  Color color;
  String url;

  ColorEntity.fromJson(Map<String, dynamic> json) {
    color = hexToColor(json['color']);
    url = json['url'];
  }

  Color hexToColor(String code) {
    if (code == null || code.isEmpty) {
      return Colors.transparent;
    }
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
