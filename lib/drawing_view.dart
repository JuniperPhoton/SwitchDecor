import 'dart:ui' as UI;
import 'package:flutter/material.dart';
import 'package:switch_decor/drawing/painter.dart';
import 'package:switch_decor/main.dart';

class DrawingView extends StatefulWidget {
  _DrawingViewState _state;

  @override
  _DrawingViewState createState() => _createState();

  _createState() {
    print("=====DrawingView_createState");
    _state = _DrawingViewState();
    return _state;
  }
}

class _DrawingViewState extends State<DrawingView> {
  CanvasPainter _painter;

  @override
  Widget build(BuildContext context) {
    print("=====build CustomPaint");
    return CustomPaint(
      painter: _getPainter(),
    );
  }

  UI.Image getContentImage() {
    var ci = DrawingParentWidget.of(context);
    return ci.contentImage;
  }

  UI.Image getFrameImage() {
    var ci = DrawingParentWidget.of(context);
    return ci.frameImage;
  }

  CustomPainter _getPainter() {
    _painter = new CanvasPainter(
        frameImage: getFrameImage(), contentImage: getContentImage());
    return _painter;
  }
}

Future<UI.Image> getRendered(
    Size size, UI.Image frameImage, UI.Image contentImage) {
  var recorder = UI.PictureRecorder();
  var canvas = Canvas(recorder);
  var painter =
      CanvasPainter(frameImage: frameImage, contentImage: contentImage);
  var size = UI.Size(frameImage.width.toDouble(), frameImage.height.toDouble());
  painter.paint(canvas, size);
  return recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}
