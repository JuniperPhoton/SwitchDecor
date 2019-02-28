import 'dart:ui' as UI;

import 'dart:ui';

import 'package:switch_decor/drawing/painter.dart';
import 'package:switch_decor/model/color_set.dart';

/// Draw [contentImage] into [frameImage] and return an [UI.Image].
///
/// return a future to be await.
Future<UI.Image> getRendered(
    UI.Image frameImage, UI.Image contentImage, ColorSet colorSet) {
  var recorder = UI.PictureRecorder();
  var canvas = Canvas(recorder);
  var painter = CanvasPainter(
      frameImage: frameImage, contentImage: contentImage, colorSet: colorSet);
  var size = UI.Size(frameImage.width.toDouble(), frameImage.height.toDouble());
  painter.paint(canvas, size);
  return recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}
