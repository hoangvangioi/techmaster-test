import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ffi/ffi.dart';
import 'package:selection_sort/selection_sort_bindings_generated.dart';
import 'package:selection_sort/selection_sort.dart';

void main() {
  runApp(const SelectionSortVisualizer());
}

class SelectionSortVisualizer extends StatefulWidget {
  const SelectionSortVisualizer({super.key});

  @override
  State<SelectionSortVisualizer> createState() =>
      _SelectionSortVisualizerState();
}

class _SelectionSortVisualizerState extends State<SelectionSortVisualizer> {
  List<int> array = [];
  List<Color> colors = [];
  bool isSorting = false;

  final colorMap = {
    0: Colors.grey,
    1: Colors.orange,
    2: Colors.red,
    3: Colors.purple,
    4: Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    _generateArray();
  }

  void _generateArray() {
    setState(() {
      array = List.generate(20, (index) => Random().nextInt(95) + 5)..shuffle();
      colors = List.generate(array.length, (index) => Colors.grey);
    });
  }

  Future<void> _startSorting() async {
    setState(() => isSorting = true);

    // Gọi hàm C
    final Pointer<Int32> arrayPointer = calloc<Int32>(array.length);
    for (int i = 0; i < array.length; i++) {
      arrayPointer[i] = array[i];
    }

    selectionSort(arrayPointer, array.length);
    int totalSteps = getTotalSteps();

    for (int i = 0; i < totalSteps; i++) {
      SortStep step = getStep(i);

      // Chuyển đổi dữ liệu
      List<int> values = List.generate(step.length, (j) => step.values[j]);
      List<int> colorCodes = List.generate(step.length, (j) => step.colors[j]);

      // Chỉ cập nhật một lần mỗi bước
      setState(() {
        array = values;
        colors =
            colorCodes.map((code) => colorMap[code] ?? Colors.grey).toList();
      });

      await Future.delayed(const Duration(milliseconds: 400));
    }

    calloc.free(arrayPointer);
    setState(() => isSorting = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Selection Sort Visualizer')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Tính chiều rộng cột động
            double columnWidth = screenWidth / array.length / 1.35;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display the array and its elements with animation
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(array.length, (index) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(
                              horizontal: (screenWidth < 600 ? 2 : 3),
                            ),
                            width: columnWidth,
                            height: array[index] * screenHeight * 0.0075,
                            color: colors[index],
                            curve: Curves.easeInOut,
                          ),
                          Positioned(
                            bottom: screenHeight < 400 ? 0 : 5,
                            child: Text(
                              array[index].toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth < 600 ? 9 : 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: screenHeight < 400 ? 7 : 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: !isSorting ? _startSorting : null,
                      child: const Text('Start Sorting'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: !isSorting ? _generateArray : null,
                      child: const Text('New Array'),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight < 400 ? 7 : 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
