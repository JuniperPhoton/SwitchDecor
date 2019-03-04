import 'package:flutter/material.dart';
import 'package:switch_decor/res/dimensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

const githubUrl = "https://github.com/JuniperPhoton/SwitchDecor";
const twitterUrl = "https://twitter.com/JuniperPhoton";
const weiboUrl = "https://weibo.com/p/1005051624312593";

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
      width: aboutIconContainerSize,
      height: aboutIconContainerSize,
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
              width: aboutIconSize,
              height: aboutIconSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  _getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "v${packageInfo.version} Build ${packageInfo.buildNumber}";
  }

  _sendEmail() async {
    return _launchUrl(
        "mailto:dengweichao@hotmail.com?subject=SwitchDecor%20Build%20${await _getBuildNumber()}%20feedback");
  }

  _openGitHub() async {
    return _launchUrl(githubUrl);
  }

  _openTwitter() async {
    return _launchUrl(twitterUrl);
  }

  _openWeibo() async {
    return _launchUrl(weiboUrl);
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Can not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      width: drawerWidth,
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
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Color(0x2e000000),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(4),
                child: Text(
                  "for Android and iOS",
                  style: _contentStyle,
                ),
              ),
              FutureBuilder(
                future: _getBuildNumber(),
                builder: (c, d) {
                  if (d.connectionState == ConnectionState.done) {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          d.data as String,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
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
                      _sendEmail();
                    }),
                    _createFeedbackWidget("github", () {
                      _openGitHub();
                    }),
                    _createFeedbackWidget("twitter", () {
                      _openTwitter();
                    }),
                    _createFeedbackWidget("weibo", () {
                      _openWeibo();
                    }),
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
