import 'package:flutter/cupertino.dart';

class Router {
  Router.push(BuildContext context, Widget widget) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return widget;
    }));
  }

  static bool pop(BuildContext dialogContext) {
   return Navigator.pop(dialogContext);
  }
}