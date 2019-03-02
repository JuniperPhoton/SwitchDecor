import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/widget/color_parent.dart';
import 'package:switch_decor/widget/misc.dart';

typedef OnTapColor = Function(int index);

class BottomActionWidget extends StatefulWidget {
  final VoidCallback onTapFab;
  final VoidCallback onTapPickImage;
  final OnTapColor onTapColor;

  const BottomActionWidget(
      {this.onTapFab, this.onTapPickImage, this.onTapColor});

  @override
  _BottomActionWidgetState createState() => _BottomActionWidgetState();
}

class _BottomActionWidgetState extends State<BottomActionWidget> {
  List<ColorSet> _getColorSets(BuildContext context) {
    var parent = ColorListParentWidget.of(context);
    return parent.colorSets;
  }

  Widget _buildListItem(BuildContext context, int index) {
    var set = _getColorSets(context)[index];
    return Container(
      width: bottomActionBarColorButtonWidth,
      height: bottomActionBarHeight,
      child: InkResponse(
        onTap: () {
          if (widget.onTapColor != null) {
            widget.onTapColor(index);
          }
        },
        child: Center(
          child: Container(
            width: bottomActionBarColorCircleSize,
            height: bottomActionBarColorCircleSize,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: set.backgroundColor,
                border: Border.all(
                    color: set.foregroundColor,
                    width: bottomActionBarColorCircleBorderWidth)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            height: bottomActionBarHeight,
            margin: EdgeInsets.only(left: 45),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(bottomActionBarCornerRadius))),
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 8, right: 60),
                    itemCount: _getColorSets(context).length,
                    itemBuilder: (c, i) {
                      return _buildListItem(context, i);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onTapPickImage != null) {
                          widget.onTapPickImage();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 4 / 3.0,
                        child: Container(
                            decoration: LeftBlurDecoration(),
                            child: Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        FloatingActionButton(
          onPressed: () {
            if (widget.onTapFab != null) {
              widget.onTapFab();
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.check),
        )
      ],
    );
  }
}
