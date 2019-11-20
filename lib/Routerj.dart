import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Router {
  Router.push(BuildContext context, Widget widget) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return widget;
    }));
  }

  static bool pop(BuildContext dialogContext) {
   return Navigator.pop(dialogContext);
  }

  static Future openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      print('Could not launch $url');
    }
  }
}