import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrible_notes/model/drawing_model.dart';
import 'package:scrible_notes/pages/drawing_screen.dart';
import 'package:scrible_notes/provider/list_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DrawingProvider>(context, listen: false).getAllList();
    return SafeArea(
      child: Scaffold(
        body: Consumer<DrawingProvider>(
          builder: (context, data, child) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              itemCount: data.items.length + 1,
              itemBuilder: (ctx, index) => index == data.items.length
                  ? Card(
                      child: TextButton(
                        onPressed: () {
                          Provider.of<DrawingProvider>(context, listen: false)
                              .add(
                            DrawingModel(
                              name: (data.items.length + 1).toString(),
                              drawingData: [],
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.add,
                          size: 22,
                        ),
                      ),
                    )
                  : Card(
                      child: TextButton(
                        onLongPress: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Remove this drawing board?"),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Provider.of<DrawingProvider>(context,
                                              listen: false)
                                          .removeAt(index);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onPressed: () {
                          if (data.items[index].drawingData.isNotEmpty) {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => DrawingPage(
                                  index: index,
                                ),
                              ),
                            )
                                .then((value) {
                              if (value != null) {
                                if (value.runtimeType ==
                                    List<Map<String, dynamic>>) {
                                  data.items[index].drawingData =
                                      value as List<Map<String, dynamic>>;
                                }
                              }
                            });
                          } else {
                            getSizeDialog(context, data, index);
                          }
                        },
                        child: Text(data.items[index].name),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  void getSizeDialog(BuildContext context, DrawingProvider data, int index) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Board Size"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Text("Width: "),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: TextEditingController()
                          ..text =
                              "${MediaQuery.of(context).size.width.toInt()}",
                        onChanged: (value) {
                          Provider.of<DrawingProvider>(context, listen: false)
                              .setSize(
                                  index,
                                  Size(
                                      int.tryParse(value)?.toDouble() ??
                                          MediaQuery.of(context).size.width,
                                      data.items[index].boardSize.height));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const Text("Height: "),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: TextEditingController()
                          ..text =
                              "${MediaQuery.of(context).size.height.toInt()}",
                        onChanged: (value) {
                          Provider.of<DrawingProvider>(context, listen: false)
                              .setSize(
                                  index,
                                  Size(
                                    data.items[index].boardSize.width,
                                    int.tryParse(value)?.toDouble() ??
                                        MediaQuery.of(context).size.height,
                                  ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (data.items[index].boardSize !=
                    MediaQuery.of(context).size) {
                  data.items[index].boardSize = MediaQuery.of(context).size;
                }

                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => DrawingPage(
                      index: index,
                    ),
                  ),
                )
                    .then((value) {
                  if (value != null) {
                    if (value.runtimeType == List<Map<String, dynamic>>) {
                      data.items[index].drawingData =
                          value as List<Map<String, dynamic>>;
                    }
                  }
                });
              },
              icon: const Icon(Icons.check),
            ),
          ],
        );
      },
    );
  }
}
