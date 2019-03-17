import 'dart:io';

import 'package:flutter/services.dart';

class ShareFromNativeCallback {
  void onPickFile(File file) {}

  void toggleDialog(bool show) {}
}

class ShareFromNativeChannel {
  MethodChannel _methodChannel = MethodChannel("ShareFromNative");

  register(ShareFromNativeCallback callback) {
    _methodChannel.setMethodCallHandler((c) {
      if (c.method == "onNewFilePath") {
        final path = c.arguments["path"];

        print("onNewFilePath: $path");

        if (path != null) {
          callback?.onPickFile(File(path));
        }
      } else if (c.method == "toggleDialog") {
        final bool show = c.arguments["show"];

        print("toggleDialog: $show");
        callback?.toggleDialog(show);
      }
    });
    _methodChannel.invokeMethod("register", null);
  }

  unregister() {
    _methodChannel.invokeMethod("unregister", null);
  }
}
