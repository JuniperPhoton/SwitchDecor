import 'package:flutter/material.dart';

typedef OnTapFab = Function(int index);

class FabActionView extends StatelessWidget {
  OnTapFab onTapFab;

  FabActionView(this.onTapFab);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () {
            if (onTapFab != null) {
              onTapFab(0);
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          mini: true,
          child: Icon(Icons.camera_alt),
        ),
        SizedBox(width: 10),
        FloatingActionButton(
          onPressed: () {
            if (onTapFab != null) {
              onTapFab(1);
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
