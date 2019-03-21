import 'package:flutter/services.dart';
import 'package:switch_decor/util/build.dart';

class LoggerBase {
  static final debug = isDebug();
  static MethodChannel _channel = MethodChannel("logger");

  static void _v(String tag, String message) {
    _channel.invokeMethod("logv", _createParams(tag, message));
  }

  static void _i(String tag, String message) {
    _channel.invokeMethod("logi", _createParams(tag, message));
  }

  static void _w(String tag, String message) {
    _channel.invokeMethod("logw", _createParams(tag, message));
  }

  static void _d(String tag, String message) {
    _channel.invokeMethod("logd", _createParams(tag, message));
  }

  static void _e(String tag, String message) {
    _channel.invokeMethod("loge", _createParams(tag, message));
  }

  static Map<String, String> _createParams(String tag, String message) {
    return {"tag": tag, "message": message};
  }

  String tag;

  LoggerBase(this.tag);

  void v(String message) {
    if (!debug) return;
    _v(tag, message);
  }

  void i(String message) {
    if (!debug) return;
    _i(tag, message);
  }

  void w(String message) {
    if (!debug) return;
    _w(tag, message);
  }

  void d(String message) {
    if (!debug) return;
    _d(tag, message);
  }

  void e(String message) {
    if (!debug) return;
    _e(tag, message);
  }
}

LoggerBase createLogger(String tag) {
  return LoggerBase(tag);
}
