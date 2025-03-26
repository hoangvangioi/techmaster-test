import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ChessBoardApp());
}

class ChessBoardApp extends StatelessWidget {
  const ChessBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const ChessBoard(title: 'Chess Board'),
    );
  }
}

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key, required this.title});

  final String title;

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  int queenRow = 0;
  int queenColumn = 0;

  void placeQueen(int row, int column) {
    setState(() {
      queenRow = row;
      queenColumn = column;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Đảm bảo căn giữa theo chiều dọc
          crossAxisAlignment:
              CrossAxisAlignment.center, // Căn giữa theo chiều ngang
          children: [
            // Căn bàn cờ vào giữa
            SizedBox(
              width: 320, // Chiều rộng cố định của bàn cờ
              height: 320, // Chiều cao cố định của bàn cờ
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int column = index % 8;
                  Color color =
                      (row + column) % 2 == 0 ? Colors.white : Colors.grey;

                  return GestureDetector(
                    onTap: () => placeQueen(row, column),
                    child: Container(
                      color: color,
                      child:
                          (row == queenRow && column == queenColumn)
                              ? Center(
                                child: Image.asset(
                                  'assets/images/queen.png', // Đặt hình ảnh quân hậu
                                  width: 38,
                                  height: 38,
                                  color: Colors.black,
                                ),
                              )
                              : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  final random = Random();
                  placeQueen(
                    random.nextInt(8),
                    random.nextInt(8),
                  ); // Đặt quân hậu ngẫu nhiên
                },
                child: const Text('Place Queen at random'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
