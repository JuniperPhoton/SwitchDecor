import 'package:flutter/material.dart';
import 'package:switch_decor/model/color_set.dart';

class ColorListParentWidget extends InheritedWidget {
  static ColorListParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorListParentWidget);
  }

  final List<ColorSet> _colorSets;
  final ScrollController _controller;
  final int _selectedIndex;

  List<ColorSet> get colorSets => _colorSets;

  ScrollController get controller => _controller;

  int get selectedIndex => _selectedIndex;

  ColorListParentWidget(this._colorSets, this._controller, this._selectedIndex,
      {@required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(ColorListParentWidget oldWidget) {
    return colorSets == oldWidget.colorSets;
  }
}
