import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:switch_decor/drawing/painter.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/res/dimensions.dart';

/// Draw [contentImage] into [frameImage] and return an [Image].
///
/// return a future to be await.
Future<ui.Image> getRendered(ui.Image frameImage, ui.Image contentImage,
    ColorSet colorSet, bool darkTextColor) {
  var copiedColorSet = ColorSet(
      backgroundColor: colorSet.backgroundColor, foregroundColor: Colors.white);
  var recorder = ui.PictureRecorder();
  var canvas = Canvas(recorder);
  var painter = CanvasPainter(
      frameImage: frameImage,
      contentImage: contentImage,
      colorSet: copiedColorSet,
      darkTextColor: darkTextColor,
      filterQuality: FilterQuality.high);

  print("======output size: $outputWidth, $outputHeight");

  // Square at my will.
  var size = Size(outputWidth, outputWidth);

  painter.paint(canvas, size);
  return recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}
