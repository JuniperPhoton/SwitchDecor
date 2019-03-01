import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';

class AboutDrawer extends StatelessWidget {
  final Color _color;

  AboutDrawer(this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      width: DRAWER_WIDTH,
    );
  }
}
