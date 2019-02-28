import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switch_decor/drawing_view.dart';
import 'package:switch_decor/platform/dir_provider.dart';
import 'package:switch_decor/util/drawing.dart';
import 'package:switch_decor/widget/fabs.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as UI;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
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
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
      var image = await getRendered(_frameImage, _contentImage);
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

  void _decodeImage() async {
    if (_frameImage != null) return;

    print("===Decode frame image");

    var bytes = await rootBundle.load("assets/images/wireframe.png");
    var list = bytes.buffer.asUint8List();

    var image = await decodeImageFromList(list);

    setState(() {
      _frameImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: Size.infinite.width,
            height: Size.infinite.height,
            child: DrawingParentWidget(_contentImage, _frameImage,
                child: DrawingView()),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "SwitchDecor",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Builder(builder: (context) {
        return FabActionView((i) {
          switch (i) {
            case 0:
              _pickImage(context);
              break;
            case 1:
              _renderToFile(context);
              break;
            default:
              break;
          }
        });
      }),
    );
  }
}

class DrawingParentWidget extends InheritedWidget {
  DrawingParentWidget(this._contentImage, this._frameImage,
      {Key key, @required Widget child})
      : super(key: key, child: child);

  UI.Image _contentImage;
  UI.Image _frameImage;

  UI.Image get contentImage => _contentImage;

  UI.Image get frameImage => _frameImage;

  static DrawingParentWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DrawingParentWidget);
  }

  @override
  bool updateShouldNotify(DrawingParentWidget oldWidget) {
    return contentImage != oldWidget.contentImage ||
        frameImage != oldWidget.frameImage;
  }
}
