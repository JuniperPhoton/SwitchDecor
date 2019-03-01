import 'package:flutter/material.dart';
import 'dart:ui' as UI;

class DrawingParentWidget extends InheritedWidget {
  static DrawingParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DrawingParentWidget);
  }

  DrawingParentWidget(this._contentImage, this._frameImage,
      {Key key, @required Widget child})
      : super(key: key, child: child);

  final UI.Image _contentImage;
  final UI.Image _frameImage;

  UI.Image get contentImage => _contentImage;

  UI.Image get frameImage => _frameImage;

  @override
  bool updateShouldNotify(DrawingParentWidget oldWidget) {
    return contentImage != oldWidget.contentImage ||
        frameImage != oldWidget.frameImage;
  }
}
