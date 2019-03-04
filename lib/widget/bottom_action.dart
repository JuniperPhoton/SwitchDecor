import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/util/color.dart';
import 'package:switch_decor/widget/misc.dart';

typedef OnTapColor = Function(int index);

class BottomActionWidget extends StatelessWidget {
  final VoidCallback onTapFab;
  final VoidCallback onTapPickImage;
  final OnTapColor onTapColor;
  final ScrollController scrollController;
  final List<ColorSet> colorSets;
  final int selectedIndex;

  const BottomActionWidget(
      {this.onTapFab,
      this.onTapPickImage,
      this.onTapColor,
      this.scrollController,
      this.colorSets,
      this.selectedIndex});

  Widget _buildListItem(BuildContext context, int index) {
    var set = colorSets[index];
    return Container(
      width: bottomActionBarColorButtonWidth,
      height: bottomActionBarHeight,
      child: InkResponse(
        onTap: () {
          if (onTapColor != null) {
            onTapColor(index);
          }
        },
        child: Center(
          child: Container(
            width: bottomActionBarColorCircleSize,
            height: bottomActionBarColorCircleSize,
            child: Container(
              child: Center(
                child: selectedIndex == index
                    ? Icon(Icons.check,
                        color: isLightColor(set.backgroundColor)
                            ? Colors.black
                            : Colors.white,
                        size: 13)
                    : Container(),
              ),
            ),
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
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 8, right: 60),
                    itemCount: colorSets.length,
                    itemBuilder: (c, i) {
                      return _buildListItem(context, i);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (onTapPickImage != null) {
                          onTapPickImage();
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
            if (onTapFab != null) {
              onTapFab();
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
