import 'package:flutter/material.dart';
import 'package:switch_decor/model/color_set.dart';

class ColorListParentWidget extends InheritedWidget {
  static ColorListParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorListParentWidget);
  }

  List<ColorSet> _colorSets;

  List<ColorSet> get colorSets => _colorSets;

  ColorListParentWidget(this._colorSets, {@required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(ColorListParentWidget oldWidget) {
    return colorSets == oldWidget.colorSets;
  }
}
