import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:switch_decor/res/dimensions.dart';
import 'package:switch_decor/widget/drawing_view.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/platform/color_picker.dart';
import 'package:switch_decor/platform/device.dart';
import 'package:switch_decor/platform/dir_provider.dart';
import 'package:switch_decor/platform/launcher.dart';
import 'package:switch_decor/res/string.dart';
import 'package:switch_decor/util/color.dart';
import 'package:switch_decor/util/drawing.dart';
import 'package:switch_decor/res/values.dart';
import 'package:switch_decor/widget/about_drawer.dart';
import 'package:switch_decor/widget/bottom_action.dart';

void main() => runApp(SwitchDecorApp());

class SwitchDecorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, fontFamily: fontFamily),
      home: MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;

  ui.Image _contentImage;
  ui.Image _frameImage;

  bool _isLoading = false;

  int _selectedColorIndex = 1;

  final List<ColorSet> _colorSets = generateDefaultColorSets();

  ColorSet get _currentColorSet => _colorSets[_selectedColorIndex];

  bool get _darkTextColor => isLightColor(_currentColorSet.backgroundColor);

  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  /// Notify user by showing snacking bar.
  /// Apply [action] if you needed.
  _notify(BuildContext context, String msg, {SnackBarAction action}) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: Duration(milliseconds: snackBarDurationMs),
        action: action));
  }

  _createActionToLaunchFile(String path) async {
    return SnackBarAction(
        label: open,
        textColor: Colors.white,
        onPressed: () async {
          if (!await Launcher.launchFile(path)) {
            print("Can not launch $path");
          }
        });
  }

  _render(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    var saveResult = false;

    var path = await DirProvider.getFileToSave(
        "${DateTime.now().millisecondsSinceEpoch}.png");

    if (path != null) {
      print("Retrieved file to save: $path");
      var file = File(path);

      file = await _renderToFile(file.path);
      saveResult = file != null;
      print("File saved: $file");
    } else {
      print("Failed to get file to save");
    }

    if (saveResult) {
      saveResult = await DirProvider.notifyScanFile(path);
    }

    var text = saveResult ? savedSuccessfully : failedToSave;
    _notify(context, text,
        action:
            Platform.isAndroid ? await _createActionToLaunchFile(path) : null);

    setState(() {
      _isLoading = false;
    });
  }

  Future<File> _renderToFile(String path) async {
    try {
      var image = await getRendered(
          _frameImage, _contentImage, _currentColorSet, _darkTextColor);
      var bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      var file = File(path);
      await file.writeAsBytes(bytes.buffer.asInt8List());
      return file;
    } catch (e) {
      return null;
    }
  }

  _extractPrimaryColors(File file) async {
    var uri = Uri.file(file.path).toString();

    var colors = await ColorPicker.pickColors(uri);
    var list = colors.map((c) {
      var color = Color(c);
      var foreground = Color.alphaBlend(maskColor, color);
      foreground = foreground.withAlpha(255);
      return ColorSet(backgroundColor: color, foregroundColor: foreground);
    }).toList();

    if (list.isNotEmpty) {
      _controller?.animateTo(0,
          duration: Duration(milliseconds: scrollDurationMs),
          curve: Curves.ease);

      _colorSets.clear();
      _colorSets.addAll(list);
      _colorSets.addAll(generateDefaultColorSets());
      _onTapColor(0);
    }
  }

  _pickImage(BuildContext context) async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) {
      return;
    }

    print("file picked: ${file.path}");

    var bytes = await file.readAsBytes();

    if (bytes == null || bytes.isEmpty) {
      _notify(context, failedToDecodeImage);
      return;
    }

    var image = await decodeImageFromList(bytes);
    if (image != null) {
      print(
          "=====file decoded====, width: ${image.width}, height: ${image.height}");
      setState(() {
        _contentImage = image;
      });

      await _extractPrimaryColors(file);
    } else {
      print("=====file NOT decoded====");
    }
  }

  _decodeImageFromPath(String path) async {
    var bytes = await rootBundle.load(path);
    var list = bytes.buffer.asUint8List();

    return await decodeImageFromList(list);
  }

  _decodeFrameImages() async {
    print("===Decode images");

    var frameImage = await _decodeImageFromPath("assets/images/wireframe.png");
    var sampleImage = await _decodeImageFromPath("assets/images/sample.jpg");

    setState(() {
      _frameImage = frameImage;
      _contentImage = sampleImage;
    });
  }

  _onTapColor(int index) {
    var currentColorSet = _currentColorSet;
    var nextColorSet = _colorSets[index];

    _colorAnimation = ColorTween(
            begin: currentColorSet.backgroundColor,
            end: nextColorSet.backgroundColor)
        .animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.forward(from: 0);
    _selectedColorIndex = index;
  }

  @override
  void initState() {
    super.initState();
    _decodeFrameImages();
    _controller = ScrollController();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: colorAnimationDurationMs));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  _buildBackgroundContainer() {
    return Container(
        color: _colorAnimation?.value ?? _currentColorSet.backgroundColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AboutDrawer(_currentColorSet.foregroundColor),
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildBackgroundContainer(),
              Align(
                alignment: Alignment.topLeft,
                child: Builder(builder: (c) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(c).openDrawer();
                    },
                    child: Container(
                      color: maskColor,
                      width: leftBannerWidth,
                    ),
                  );
                }),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: leftBannerWidth,
                    margin: EdgeInsets.only(top: 12),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        aboutTextVertical,
                        style: TextStyle(
                            color: Colors.white, fontSize: aboutTitleFontSize),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: Size.infinite.width,
            height: Size.infinite.height,
            child: Container(
              margin: EdgeInsets.only(left: leftBannerWidth),
              child: DrawingView(
                contentImage: _contentImage,
                frameImage: _frameImage,
                darkTextColor: _darkTextColor,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Container(
              margin: EdgeInsets.only(top: titleMargin),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  appName.toUpperCase(),
                  style: TextStyle(
                      color: _darkTextColor ? Colors.black : Colors.white,
                      fontSize: titleFontSize,
                      letterSpacing: titleLetterSpacing,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Builder(builder: (c) {
        return Container(
          padding: EdgeInsets.only(
              bottom: isIPhoneX(context)
                  ? MediaQuery.of(context).padding.bottom / 2
                  : 0),
          child: BottomActionWidget(
              onTapFab: () {
                _render(c);
              },
              onTapPickImage: () {
                _pickImage(c);
              },
              onTapColor: (index) {
                _onTapColor(index);
              },
              selectedIndex: _selectedColorIndex,
              colorSets: _colorSets,
              scrollController: _controller,
              isLoading: _isLoading),
        );
      }),
    );
  }
}
