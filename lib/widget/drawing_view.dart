import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:switch_decor/drawing/painter.dart';

class DrawingView extends StatelessWidget {
  final ui.Image frameImage;
  final ui.Image contentImage;
  final bool darkTextColor;

  DrawingView({this.frameImage, this.contentImage, this.darkTextColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: new CanvasPainter(
            frameImage: frameImage,
            contentImage: contentImage,
            darkTextColor: darkTextColor));
  }
}
