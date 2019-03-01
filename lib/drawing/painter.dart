import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';
import 'package:switch_decor/model/color_set.dart';

class CanvasPainter extends CustomPainter {
  static const TINT_FRAME = false;

  UI.Image frameImage;
  UI.Image contentImage;

  Matrix4 matrix;
  Float64List _list;

  ColorSet colorSet;

  CanvasPainter(
      {this.frameImage, this.contentImage, this.matrix, this.colorSet});

  final _paint = Paint();
  final _framePaint = Paint();
  final _contentPaint = Paint();

  _getDstRect(int w, int h, Size canvasSize) {
    if (canvasSize.height.isInfinite) {
      return Rect.zero;
    }
    var frameRatio = w.toDouble() / h;
    var canvasRatio = canvasSize.width / canvasSize.height;

    double targetWidth;
    double targetHeight;
    double left;
    double top;

    if (frameRatio < canvasRatio) {
      targetHeight = canvasSize.height;
      targetWidth = targetHeight * frameRatio;
      left = (canvasSize.width - targetWidth) / 2;
      top = (canvasSize.height - targetHeight) / 2;
    } else {
      targetWidth = canvasSize.width;
      targetHeight = targetWidth / frameRatio;
      left = (canvasSize.width - targetWidth) / 2;
      top = (canvasSize.height - targetHeight) / 2;
    }

    return Rect.fromLTWH(left, top, targetWidth, targetHeight);
  }

  _getRectFromImage(UI.Image image) {
    return Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
  }

  @override
  void paint(Canvas canvas, Size size) async {
    _paint.color = Colors.black;

    if (matrix != null && _list == null) {
      _list = Float64List(16);
    }

    matrix?.copyIntoArray(_list);

    if (colorSet != null) {
      canvas.drawColor(colorSet.backgroundColor, BlendMode.src);
    }

    canvas.save();

    if (_list != null) {
      canvas.transform(_list);
    }

    if (frameImage != null) {
      var frameRect = _getDstRect(frameImage.width, frameImage.height, size);

      if (TINT_FRAME && colorSet != null) {
        _framePaint.colorFilter =
            ColorFilter.mode(colorSet.foregroundColor, BlendMode.srcIn);
      }

      canvas.drawImageRect(
          frameImage, _getRectFromImage(frameImage), frameRect, _framePaint);

      if (contentImage != null) {
        var leftRatio = FRAME_LEFT_RATIO / frameImage.width;
        var topRatio = FRAME_TOP_RATIO / frameImage.height;
        var rightRatio = FRAME_RIGHT_RATIO / frameImage.width;
        var bottomRatio = FRAME_BOTTOM_RATIO / frameImage.height;

        var contentRect = Rect.fromLTRB(
            frameRect.left + leftRatio * frameRect.width,
            frameRect.top + topRatio * frameRect.height,
            frameRect.left + rightRatio * frameRect.width,
            frameRect.top + bottomRatio * frameRect.height);

        canvas.drawImageRect(contentImage, _getRectFromImage(contentImage),
            contentRect, _contentPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CanvasPainter other) {
    return true;
  }
}
