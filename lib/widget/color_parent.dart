import 'package:flutter/material.dart';
import 'package:switch_decor/model/color_set.dart';

class ColorListParentWidget extends InheritedWidget {
  static ColorListParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorListParentWidget);
  }

  final List<ColorSet> _colorSets;
  final ScrollController _controller;

  List<ColorSet> get colorSets => _colorSets;
  ScrollController get controller => _controller;

  ColorListParentWidget(this._colorSets, this._controller,
      {@required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(ColorListParentWidget oldWidget) {
    return colorSets == oldWidget.colorSets;
  }
}
