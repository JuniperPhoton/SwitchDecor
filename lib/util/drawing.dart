import 'dart:ui' as UI;

import 'dart:ui';

import 'package:switch_decor/drawing/painter.dart';

/// Draw [contentImage] into [frameImage] and return an [UI.Image].
///
/// return a future to be await.
Future<UI.Image> getRendered(UI.Image frameImage, UI.Image contentImage) {
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
