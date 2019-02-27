import 'dart:ui';

Color hexToColor(String code) {
  if (code.startsWith("#")) {
    code = code.substring(1);
  }
  return new Color(int.parse(code, radix: 16));
}