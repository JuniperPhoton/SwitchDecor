import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';

class WindowFeatureChannel {
  static const platform = const MethodChannel('WindowFeature');

  static Future<bool> setNavigationBarColor(Color color,
      {bool isLight = true}) async {
    if (Platform.isIOS) {
      return Future.value(false);
    }

    await platform
        .invokeMethod("setNavigationBar", {"color": color.value, "isLight": isLight});

    return Future.value(true);
  }
}
