import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:switch_decor/main.dart';
import 'package:switch_decor/util/build.dart';
import 'package:switch_decor/util/color.dart';

const double LEFT = 375;
const double TOP = 221;
const double RIGHT = 1144;
const double BOTTOM = 650;

class CanvasPainter extends CustomPainter {
  UI.Image frameImage;
  UI.Image contentImage;

  Matrix4 matrix;
  Float64List _list;

  CanvasPainter({this.frameImage, this.contentImage, this.matrix});

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

    canvas.drawColor(hexToColor("ff40708a"), BlendMode.src);
    canvas.save();

    if (_list != null) {
      canvas.transform(_list);
    }

    if (frameImage != null) {
      var frameRect = _getDstRect(frameImage.width, frameImage.height, size);

      _framePaint.colorFilter =
          ColorFilter.mode(hexToColor("ff164c62"), BlendMode.srcIn);

      canvas.drawImageRect(
          frameImage, _getRectFromImage(frameImage), frameRect, _framePaint);

      if (contentImage != null) {
        var leftRatio = LEFT / frameImage.width;
        var topRatio = TOP / frameImage.height;
        var rightRatio = RIGHT / frameImage.width;
        var bottomRatio = BOTTOM / frameImage.height;

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
