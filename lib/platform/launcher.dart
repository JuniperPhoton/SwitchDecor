import 'dart:io';

import 'package:flutter/services.dart';
import 'package:switch_decor/platform/logger.dart';

final logger = createLogger("Launcher");

class Launcher {
  static const platform = const MethodChannel('Launcher');

  static Future<bool> launchFile(String path) async {
    try {
      if (Platform.isIOS) {
        return Future.value(true);
      }
      final Future<bool> result =
          platform.invokeMethod('launchFile', {"path": path});
      return result;
    } on PlatformException catch (e) {
      logger.e("Failed to launchFile: '${e.message}'.");
      return Future.value(false);
    }
  }
}
