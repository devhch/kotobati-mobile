/*
* Created By Mirai Devs.
* On 06/22/2023.
*/

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

extension BottomPadding on BuildContext {
  double get topPadding => MediaQuery.of(this).padding.top;

  double get bottomAdding => MediaQuery.of(this).padding.bottom;
}

extension PadLeft on int {
  String padLeft({int width = 2}) {
    return toString().padLeft(width, '0');
  }
}

extension GenerateTheName on String {
  String get generateTheName {
    String imageString = '';
    if (isNotEmpty) {
      final List<String> split = this.split(" ");
      for (int i = 0; i < split.length; i++) {
        if (i < 2 && split[i].isNotEmpty) {
          imageString += split[i][0];
        }
      }
    }
    return imageString.toUpperCase();
  }
}

extension ConvertUint8ListString on String {
  Uint8List get convertStringToUint8List {
    // final List<int> codeUnits = this.codeUnits;
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);

    List<int> list = utf8.encode(this);
    Uint8List bytes = Uint8List.fromList(list);

    return bytes;
  }
}

extension ConvertUint8List on Uint8List {
  String get convertUint8ListToString {
    //  return String.fromCharCodes(this);
    return utf8.decode(this);
  }
}
