import 'package:flutter/services.dart';

class ColorPicker {
  static const platform = const MethodChannel('ColorPicker');

  static Future<List<int>> pickColors(String uri) async {
    try {
      return (await platform.invokeMethod('pickColors', {"uri": uri})).cast<int>();
    } on PlatformException catch (e) {
      print("Failed to pickColors: '${e.message}'.");
      return Future.value(null);
    }
  }
}
