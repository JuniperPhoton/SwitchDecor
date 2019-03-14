import 'dart:ui';

class ColorSet {
  Color tintColor;
  Color foregroundColor;
  Color backgroundColor;

  ColorSet(
      {this.backgroundColor, this.foregroundColor, this.tintColor}) {
    if (tintColor == null) {
      tintColor = foregroundColor;
    }
  }
}

List<ColorSet> generateDefaultColorSets() {
  return [
    ColorSet(
        backgroundColor: Color(0x00000000),
        foregroundColor: Color(0xff000000),
        tintColor: Color(0xffffffff)),
    ColorSet(
        backgroundColor: Color(0x00000000),
        foregroundColor: Color(0xff000000),
        tintColor: Color(0xff000000)),
    ColorSet(
        backgroundColor: Color(0xff54bddb), foregroundColor: Color(0xff3b8499)),
    ColorSet(
        backgroundColor: Color(0xffabdbe6), foregroundColor: Color(0xff7ca0a8)),
    ColorSet(
        backgroundColor: Color(0xff528B7C), foregroundColor: Color(0xff396157)),
    ColorSet(
        backgroundColor: Color(0xffDD6991), foregroundColor: Color(0xff9b4965)),
    ColorSet(
        backgroundColor: Color(0xffd32d26), foregroundColor: Color(0xff941f1b)),
    ColorSet(
        backgroundColor: Color(0xffeda13a), foregroundColor: Color(0xffa67129)),
    ColorSet(
        backgroundColor: Color(0xff4242ef), foregroundColor: Color(0xff2e2ea7)),
  ];
}
