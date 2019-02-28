import 'dart:ui';

/// Parse color string to [Color].
Color hexToColor(String code) {
  if (code.startsWith("#")) {
    code = code.substring(1);
  }
  return new Color(int.parse(code, radix: 16));
}