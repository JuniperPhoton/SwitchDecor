import 'package:flutter/material.dart';
import 'package:switch_decor/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutDrawer extends StatelessWidget {
  final Color _color;

  AboutDrawer(this._color);

  final _titleStyle =
      TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);

  final _subTitleStyle =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

  final _contentStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
  );

  _createVerticalSpace() {
    return SizedBox(
      height: 30,
    );
  }

  _createFeedbackWidget(String svgName, VoidCallback callback) {
    return Container(
      width: ABOUT_ICON_ROOT_SIZE,
      height: ABOUT_ICON_ROOT_SIZE,
      child: Material(
        color: Color(0x00ffffff),
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: () {
            callback();
          },
          child: Center(
            child: SvgPicture.asset(
              "assets/vector/$svgName.svg",
              width: ABOUT_ICON_SIZE,
              height: ABOUT_ICON_SIZE,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      width: DRAWER_WIDTH,
      height: double.infinity,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createVerticalSpace(),
              Text(
                "SwitchDecor",
                style: _titleStyle,
              ),
              _createVerticalSpace(),
              Container(
                decoration: BoxDecoration(
                    color: Color(0x2e000000),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(4),
                child: Text(
                  "for Android and iOS",
                  style: _contentStyle,
                ),
              ),
              _createVerticalSpace(),
              Text(
                "CREDIT",
                style: _subTitleStyle,
              ),
              _createVerticalSpace(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This project is written in Flutter, which is a open-source project that"
                      " allows you to build beautiful native apps on iOS and Android from a single codebase.",
                  style: _contentStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              _createVerticalSpace(),
              Text(
                "DEVELOPER",
                style: _subTitleStyle,
              ),
              _createVerticalSpace(),
              Text(
                "JuniperPhoton",
                style: _contentStyle,
              ),
              _createVerticalSpace(),
              Text(
                "FEEDBACK",
                style: _subTitleStyle,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _createFeedbackWidget("email", () {
                      print("on click email");
                    }),
                    _createFeedbackWidget("github", () {}),
                    _createFeedbackWidget("twitter", () {}),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
