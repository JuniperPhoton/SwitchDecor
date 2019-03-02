import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DrawingParentWidget extends InheritedWidget {
  static DrawingParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DrawingParentWidget);
  }

  DrawingParentWidget(this._contentImage, this._frameImage,
      {Key key, @required Widget child})
      : super(key: key, child: child);

  final ui.Image _contentImage;
  final ui.Image _frameImage;

  ui.Image get contentImage => _contentImage;

  ui.Image get frameImage => _frameImage;

  @override
  bool updateShouldNotify(DrawingParentWidget oldWidget) {
    return contentImage != oldWidget.contentImage ||
        frameImage != oldWidget.frameImage;
  }
}
