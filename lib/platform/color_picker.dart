import 'package:flutter/services.dart';
import 'package:switch_decor/platform/logger.dart';

final logger = createLogger("ColorPicker");

class ColorPicker {
  static const platform = const MethodChannel('ColorPicker');

  static Future<List<int>> pickColors(String uri) async {
    try {
      return (await platform.invokeMethod('pickColors', {"uri": uri})).cast<int>();
    } on PlatformException catch (e) {
      logger.e("Failed to pickColors: '${e.message}'.");
      return Future.value(null);
    }
  }
}
