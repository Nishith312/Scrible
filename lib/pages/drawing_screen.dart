import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:provider/provider.dart';
import 'package:scrible_notes/pages/triangle_draw.dart';
import 'package:scrible_notes/provider/list_provider.dart';
import 'package:scrible_notes/model/drawing_model.dart';

class DrawingPage extends StatefulWidget {
  final int index;

  const DrawingPage({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<DrawingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DrawingPage> {
  final DrawingController _drawingController = DrawingController();
// create some values
  Color pickerColor = Colors.cyan;
  Color currentColor = Colors.purple;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setInitData(Provider.of<DrawingProvider>(context, listen: false));

        if (!Platform.isAndroid && !Platform.isIOS) {
          FirebaseDatabase.instance
              .ref("DrawingData")
              .child((widget.index + 1).toString())
              .onValue
              .listen((event) {
            var snapshot = event.snapshot.value as Map;
            Provider.of<DrawingProvider>(context, listen: false)
                .getModel(widget.index, DrawingModel.fromJson(snapshot));
          });
        }
      }
    });

    super.initState();
  }

  void changeColorDialog() {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              _drawingController.setStyle(color: currentColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  // Future<void> _getImageData() async {
  //   final Uint8List? data =
  //       (await _drawingController.getImageData())?.buffer.asUint8List();
  //   if (data == null) {
  //     return;
  //   }

  //   if (mounted) {
  //     showDialog<void>(
  //       context: context,
  //       builder: (BuildContext c) {
  //         return Material(
  //           color: Colors.transparent,
  //           child: InkWell(
  //               onTap: () => Navigator.pop(c), child: Image.memory(data)),
  //         );
  //       },
  //     );
  //   }
  // }

  void setInitData(DrawingProvider data) {
    for (var element in data.items[widget.index].drawingData) {
      if (element["type"] == "SimpleLine") {
        _drawingController.addContent(SimpleLine.fromJson(element));
      }
      if (element["type"] == "Rectangle") {
        _drawingController.addContent(Rectangle.fromJson(element));
      }
      if (element["type"] == "Circle") {
        _drawingController.addContent(Circle.fromJson(element));
      }
      if (element["type"] == "Triangle") {
        _drawingController.addContent(Triangle.fromJson(element));
      }
      if (element["type"] == "Eraser") {
        _drawingController.addContent(Eraser.fromJson(element));
      }
      if (element["type"] == "SmoothLine") {
        _drawingController.addContent(SmoothLine.fromJson(element));
      }
      if (element["type"] == "StraightLine") {
        _drawingController.addContent(StraightLine.fromJson(element));
      }
      if (element["type"] == "EmptyContent") {
        _drawingController.addContent(EmptyContent.fromJson(element));
      }
    }
    _drawingController.setStyle(
      color: currentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _drawingController.getJsonList());
      },
      child: Consumer<DrawingProvider>(builder: (context, data, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Drawing Board ${data.items[widget.index].name}'),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: GestureDetector(
                  onTap: changeColorDialog,
                  child: CircleAvatar(
                    backgroundColor: currentColor,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                  child: DrawingBoard(
                controller: _drawingController,
                background: Container(
                  width: data.items[widget.index].boardSize.width,
                  height: data.items[widget.index].boardSize.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    color: Colors.white,
                  ),
                ),
                onPointerUp: (pue) {
                  data.items[widget.index].drawingData =
                      _drawingController.getJsonList();
                  Provider.of<DrawingProvider>(context, listen: false)
                      .updateListCollection(widget.index);
                },
                showDefaultActions: !kIsWeb ? true : false,
                showDefaultTools: !kIsWeb ? true : false,
                defaultToolsBuilder: (Type t, _) {
                  return DrawingBoard.defaultTools(t, _drawingController)
                    ..insert(
                      1,
                      DefToolItem(
                        icon: Icons.change_history_rounded,
                        isActive: t == Triangle,
                        onTap: () =>
                            _drawingController.setPaintContent(Triangle()),
                      ),
                    );
                },
              )),
            ],
          ),
        );
      }),
    );
  }
}
