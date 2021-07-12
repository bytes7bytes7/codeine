import 'dart:convert';

import 'package:flutter/material.dart';

abstract class BytesService {
  static String subByte({
    String data,
    String startString,
    String endString,
    bool cutStart = false,
    bool cutEnd = true,
  }) {
    String start = '', end = '';
    if (startString != null) {
      utf8.encode(startString).forEach((byte) {
        start += byte.toString() + ', ';
      });
      if (cutStart) {
        data = data.substring(data.indexOf(start) + start.length);
      } else {
        data = data.substring(data.indexOf(start));
      }
    }
    if (endString != null) {
      utf8.encode(endString).forEach((byte) {
        end += byte.toString() + ', ';
      });
      if (cutEnd) {
        data = data.substring(0, data.indexOf(end));
      } else {
        data = data.substring(0, data.indexOf(end) + end.length);
      }
    }

    return data;
  }

  static List<String> splitByte({String data, @required String splitString}) {
    String cut = '';
    if (splitString != null) {
      utf8.encode(splitString).forEach((byte) {
        cut += byte.toString() + ', ';
      });
      return data.split(cut);
    }
    return [];
  }

  static List<int> getInts(String data) {
    List<String> bytesStr = data.split(',');
    bytesStr = bytesStr.map<String>((e) => e.trim()).toList();
    bytesStr.removeWhere((element) => element.isEmpty);
    List<int> bytes = bytesStr.map<int>((byte) {
      return int.parse(byte);
    }).toList();
    return bytes;
  }
}
