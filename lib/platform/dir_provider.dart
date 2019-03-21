import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:switch_decor/platform/logger.dart';

final logger = createLogger("DirProvider");

class DirProvider {
  static const platform = const MethodChannel('DirProvider');

  static Future<String> getFileToSave(String name) async {
    try {
      if (Platform.isIOS) {
        var appDocDir = await getApplicationDocumentsDirectory();
        var screenDir = Directory(appDocDir.path + "/screen");
        if (!await screenDir.exists()) {
          await screenDir.create();
        }
        return Uri.parse("${screenDir.path}/$name").path;
      }
      final Future<String> result =
          platform.invokeMethod('getPictureDir', {"name": name});
      return result;
    } on PlatformException catch (e) {
      logger.e("Failed to getPictureDir: '${e.message}'.");
      return Future.value(null);
    }
  }

  static Future<bool> notifyScanFile(String path) async {
    try {
      final Future<bool> result =
          platform.invokeMethod('notifyScanFile', {"path": path});
      return result;
    } on PlatformException catch (e) {
      logger.e("Failed to getPictureDir: '${e.message}'.");
      return Future.value(false);
    }
  }
}
