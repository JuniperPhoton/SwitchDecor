import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';

class LeftBlurDecoration extends BoxDecoration {
  LeftBlurDecoration()
      : super(
            gradient: LinearGradient(colors: [
              Color(0x00ffffff),
              Color(0xccffffff),
              Colors.white,
              Colors.white,
              Colors.white
            ], stops: [
              0.0,
              0.1,
              0.2,
              0.3,
              1
            ], tileMode: TileMode.clamp),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(BOTTOM_ACTION_BAR_CORNER_RADIUS),
                bottomRight: Radius.circular(BOTTOM_ACTION_BAR_CORNER_RADIUS)));
}
