import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:switch_decor/res/dimensions.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/util/build.dart';

class CanvasPainter extends CustomPainter {
  static const TINT_FRAME = false;
  static const TINT_FRAME_ON_DARK_TEXT = true;

  ui.Image frameImage;
  ui.Image contentImage;

  Matrix4 matrix;
  Float64List _list;

  ColorSet colorSet;
  bool darkTextColor = false;

  FilterQuality filterQuality;

  CanvasPainter(
      {this.frameImage,
      this.contentImage,
      this.matrix,
      this.colorSet,
      this.darkTextColor = false,
      this.filterQuality = FilterQuality.none});

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

  _getRectFromImage(ui.Image image, {double ratio = 0.0}) {
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    if (ratio == 0) {
      return Rect.fromLTWH(0, 0, imageWidth, imageHeight);
    } else {
      final imageRatio = imageWidth / imageHeight;
      double targetWidth;
      double targetHeight;
      if (imageRatio >= ratio) {
        targetHeight = imageHeight;
        targetWidth = targetHeight * ratio;
      } else {
        targetWidth = imageWidth;
        targetHeight = targetWidth / ratio;
      }

      final left = (imageWidth - targetWidth) / 2;
      final top = (imageHeight - targetHeight) / 2;
      return Rect.fromLTWH(left, top, targetWidth, targetHeight);
    }
  }

  @override
  void paint(Canvas canvas, Size size) async {
    _paint.color = Colors.black;

    if (matrix != null && _list == null) {
      _list = Float64List(16);
    }

    matrix?.copyIntoArray(_list);

    // Draw the background color
    if (colorSet != null) {
      canvas.drawColor(colorSet.backgroundColor, BlendMode.src);
    }

    // Transform canvas if needed.
    if (_list != null) {
      canvas.transform(_list);
    }

    // Draw the frame image on top of background.
    if (frameImage != null) {
      var frameRect = _getDstRect(frameImage.width, frameImage.height, size);

      // Tint if needed.
      if (TINT_FRAME && colorSet != null) {
        _framePaint.colorFilter =
            ColorFilter.mode(colorSet.foregroundColor, BlendMode.srcIn);
      } else if (darkTextColor && TINT_FRAME_ON_DARK_TEXT) {
        _framePaint.colorFilter =
            ColorFilter.mode(Colors.black, BlendMode.srcIn);
      }

      _framePaint.filterQuality = filterQuality;

      canvas.drawImageRect(
          frameImage, _getRectFromImage(frameImage), frameRect, _framePaint);

      // Draw the user content image
      if (contentImage != null) {
        var leftRatio = frameLeftRatio / frameImage.width;
        var topRatio = frameTopRatio / frameImage.height;
        var rightRatio = frameRightRatio / frameImage.width;
        var bottomRatio = frameBottomRatio / frameImage.height;

        var contentRect = Rect.fromLTRB(
            frameRect.left + leftRatio * frameRect.width,
            frameRect.top + topRatio * frameRect.height,
            frameRect.left + rightRatio * frameRect.width,
            frameRect.top + bottomRatio * frameRect.height);

        _contentPaint.filterQuality = filterQuality;

        var src = _getRectFromImage(contentImage, ratio: frameAspectRatio);

        if (isDebug() && filterQuality == FilterQuality.high) {
          print("========output src content rect: $src, frameRect: $frameRect");
          print("========output dst content rect: $contentRect");
        }

        canvas.drawImageRect(contentImage, src, contentRect, _contentPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter other) {
    return true;
  }
}
