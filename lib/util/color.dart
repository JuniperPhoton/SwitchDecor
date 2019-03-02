import 'dart:ui';

/// Parse color string to [Color].
Color hexToColor(String code) {
  if (code.startsWith("#")) {
    code = code.substring(1);
  }
  if (code.length == 6) {
    code = "FF" + code;
  }
  return new Color(int.parse(code, radix: 16));
}

bool isLightColor(Color c) => _getLuma(c) > 220;

int _getLuma(Color c) {
  return (0.299 * c.red + 0.587 * c.green + 0.114 * c.blue).toInt();
}
