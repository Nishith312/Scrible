import 'dart:convert';

import 'package:flutter/material.dart';

class DrawingModel {
  final String name;
  List<Map<String, dynamic>> drawingData;
  Size boardSize;

  DrawingModel(
      {required this.name,
      required this.drawingData,
      this.boardSize = const Size(1080, 1980)});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "drawingData": jsonEncode(drawingData.map((e) => e).toList()),
      "boardSize": {
        "height": boardSize.height,
        "width": boardSize.width,
      },
    };
  }

  static DrawingModel fromJson(Map<dynamic, dynamic> json) => DrawingModel(
        name: json["name"] ?? "",
        drawingData: List<Map<String, dynamic>>.from(
            jsonDecode(json["drawingData"]) ?? []),
        boardSize: Size(
          double.tryParse(json["boardSize"]["width"].toString()) ?? 1080.0,
          double.tryParse(json["boardSize"]["height"].toString()) ?? 1980.0,
        ),
      );
}
