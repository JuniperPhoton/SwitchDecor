import 'dart:io';

import 'package:flutter/material.dart';

bool isIPhoneX(BuildContext context) {
  if (Platform.isIOS) {
    return MediaQuery.of(context).padding.bottom > 0;
  }
  return false;
}