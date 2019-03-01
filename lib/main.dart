import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switch_decor/dimensions.dart';
import 'package:switch_decor/drawing_view.dart';
import 'package:switch_decor/model/color_set.dart';
import 'package:switch_decor/platform/device.dart';
import 'package:switch_decor/platform/dir_provider.dart';
import 'package:switch_decor/util/drawing.dart';
import 'package:switch_decor/widget/about_drawer.dart';
import 'package:switch_decor/widget/color_parent.dart';
import 'package:switch_decor/widget/drawing_parent.dart';
import 'package:switch_decor/widget/bottom_action.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as UI;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black, fontFamily: "FiraCode"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UI.Image _contentImage;
  UI.Image _frameImage;

  _notify(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1000),
    ));
  }

  _renderToFile(BuildContext context) async {
    var saveResult = false;

    var path = await DirProvider.getFileToSave(
        "${DateTime.now().millisecondsSinceEpoch}.png");

    if (path != null) {
      print("File to save: $path");
      var file = File(path);
      saveResult = await _saveImage(file.path);
    } else {
      print("Failed to get file to save");
    }

    if (saveResult) {
      saveResult = await DirProvider.notifyScanFile(path);
    }

    var text = saveResult ? "Succeed to save to file" : "Failed to save";
    _notify(context, text);
  }

  Future<bool> _saveImage(String path) async {
    try {
      var image = await getRendered(_frameImage, _contentImage, _colorSet);
      var bytes = await image.toByteData(format: UI.ImageByteFormat.png);
      File(path).writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);
      return true;
    } catch (e) {
      return false;
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
      _notify(context, "Failed to decode image");
      return;
    }

    var image = await decodeImageFromList(bytes);
    if (image != null) {
      print("=====file decoded====");
      setState(() {
        _contentImage = image;
      });
    } else {
      print("=====file NOT decoded====");
    }
  }

  @override
  void initState() {
    super.initState();
    _decodeImage();
  }

  decodeImage(String path) async {
    var bytes = await rootBundle.load(path);
    var list = bytes.buffer.asUint8List();

    return await decodeImageFromList(list);
  }

  void _decodeImage() async {
    print("===Decode images");

    var frameImage = await decodeImage("assets/images/wireframe.png");
    var sampleImage = await decodeImage("assets/images/sample.jpg");

    setState(() {
      _frameImage = frameImage;
      _contentImage = sampleImage;
    });
  }

  int _selectedColorIndex = 0;

  final List<ColorSet> _colorSets = generateDefaultColorSets();

  ColorSet get _colorSet => _colorSets[_selectedColorIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AboutDrawer(_colorSet.foregroundColor),
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(color: _colorSet.backgroundColor),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  color: _colorSet.foregroundColor,
                  width: LEFT_BANNER_WIDTH,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: LEFT_BANNER_WIDTH,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "A\nB\nO\nU\nT",
                        style: TextStyle(color: Colors.white),
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
              margin: EdgeInsets.only(left: LEFT_BANNER_WIDTH),
              child: DrawingParentWidget(_contentImage, _frameImage,
                  child: DrawingView()),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Container(
              margin: EdgeInsets.only(
                  left: TITLE_MARGIN + LEFT_BANNER_WIDTH, top: TITLE_MARGIN),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "HOME".toUpperCase(),
                  style:
                      TextStyle(color: Colors.white, fontSize: TITLE_FONT_SIZE),
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
          child: ColorListParentWidget(
            _colorSets,
            child: BottomActionWidget(
              onTapFab: () {
                _renderToFile(c);
              },
              onTapPickImage: () {
                _pickImage(c);
              },
              onTapColor: (index) {
                setState(() {
                  _selectedColorIndex = index;
                });
              },
            ),
          ),
        );
      }),
    );
  }
}
