import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scrible_notes/model/drawing_model.dart';

class DrawingProvider extends ChangeNotifier {
  final List<DrawingModel> _items = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  UnmodifiableListView<DrawingModel> get items => UnmodifiableListView(_items);

  void add(DrawingModel item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void setSize(int index, Size size) {
    _items[index].boardSize = size;
  }

  Future<void> updateListCollection(int index) async {
    await database
        .ref("DrawingData")
        .child(_items[index].name)
        .set(_items[index].toJson());
  }

  Future<void> getAllList() async {
    _items.clear();
    var dataSnap = await database.ref("DrawingData").get();
    for (var element in dataSnap.children) {
      _items.add(DrawingModel.fromJson(element.value as Map));
      notifyListeners();
    }
  }

  Future<void> getModel(int index, DrawingModel data) async {
    _items[index] = data;
    notifyListeners();
  }
}
