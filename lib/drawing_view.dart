import 'package:flutter/material.dart';
import 'package:switch_decor/drawing/painter.dart';
import 'package:switch_decor/main.dart';

class DrawingView extends StatefulWidget {
  @override
  _DrawingViewState createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  @override
  Widget build(BuildContext context) {
    var parent = DrawingParentWidget.of(context);
    var contentImage = parent.contentImage;
    var frameImage = parent.frameImage;

    print("=====build CustomPaint");
    return CustomPaint(
        painter: new CanvasPainter(
            frameImage: frameImage, contentImage: contentImage));
  }
}
