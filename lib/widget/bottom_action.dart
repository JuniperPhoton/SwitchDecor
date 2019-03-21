import 'package:flutter/material.dart';
import 'package:switch_decor/res/dimensions.dart';
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
  final bool isLoading;

  final cardBorder = const RoundedRectangleBorder(
      borderRadius:
      BorderRadius.all(Radius.circular(bottomActionBarCornerRadius)));

  const BottomActionWidget(
      {this.onTapFab,
      this.onTapPickImage,
      this.onTapColor,
      this.scrollController,
      this.colorSets,
      this.selectedIndex,
      this.isLoading});

  Widget _buildFab() {
    if (!isLoading) {
      return FloatingActionButton(
        onPressed: () {
          if (onTapFab != null) {
            onTapFab();
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Icon(Icons.check),
      );
    } else {
      return FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: Container(
            width: progressBarSize,
            height: progressBarSize,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: progressBarStrokeWidth,
            )),
      );
    }
  }

  Widget _buildColorList(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 8, right: 60),
      itemCount: colorSets.length,
      itemBuilder: (c, i) {
        return _buildListItem(context, i);
      },
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    var set = colorSets[index];
    return Container(
      width: bottomActionBarColorButtonWidth,
      height: bottomActionBarHeight,
      child: InkResponse(
        onTap: () {
          if (onTapColor != null && !isLoading) {
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

  Widget _buildGallery() {
    return GestureDetector(
      onTap: () {
        if (onTapPickImage != null && !isLoading) {
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
              shape: cardBorder,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                      child: _buildColorList(context)),
                  Align(
                    child: _buildGallery(),
                    alignment: Alignment.centerRight,
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        _buildFab()
      ],
    );
  }
}
