import 'dart:io';

import 'package:flutter/services.dart';

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
      print("Failed to launchFile: '${e.message}'.");
      return Future.value(false);
    }
  }
}
