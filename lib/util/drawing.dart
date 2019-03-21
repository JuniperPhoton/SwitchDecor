import 'dart:ui';

import 'package:switch_decor/drawing/painter.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/platform/logger.dart';
import 'package:switch_decor/res/dimensions.dart';

final logger = createLogger("drawing");

/// Draw [contentImage] into [frameImage] and return an [Image].
///
/// return a future to be await.
Future<Image> getRendered(Image frameImage, Image contentImage,
    ColorSet colorSet, bool darkTextColor) {
  var recorder = PictureRecorder();
  var canvas = Canvas(recorder);
  var painter = CanvasPainter(
      frameImage: frameImage,
      contentImage: contentImage,
      colorSet: colorSet,
      darkTextColor: darkTextColor,
      filterQuality: FilterQuality.high);

  logger.w("output size: $outputWidth, $outputHeight");

  // Square at my will.
  var size = Size(outputWidth, outputWidth);

  painter.paint(canvas, size);
  return recorder
      .endRecording()
      .toImage(size.width.floor(), size.height.floor());
}
