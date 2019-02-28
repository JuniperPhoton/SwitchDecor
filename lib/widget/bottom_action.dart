import 'package:flutter/material.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/widget/color_parent.dart';

typedef OnTapColor = Function(int index);

class BottomActionWidget extends StatefulWidget {
  VoidCallback onTapFab;
  VoidCallback onTapPickImage;
  OnTapColor onTapColor;

  BottomActionWidget({this.onTapFab, this.onTapPickImage, this.onTapColor});

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
      width: 50,
      height: 60,
      child: InkWell(
        splashColor: set.backgroundColor,
        onTap: () {
          if (widget.onTapColor != null) {
            widget.onTapColor(index);
          }
        },
        child: Center(
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: set.backgroundColor,
                border: Border.all(color: set.foregroundColor, width: 3)),
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
            height: 60,
            margin: EdgeInsets.only(left: 45),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 8, right: 40),
                    itemCount: _getColorSets(context).length,
                    itemBuilder: (c, i) {
                      return _buildListItem(context, i);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (widget.onTapPickImage != null) {
                          widget.onTapPickImage();
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 4 / 3.0,
                        child: Container(
                            decoration: BoxDecoration(
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
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
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
