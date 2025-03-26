import 'package:flutter/material.dart';

void main() {
  runApp(EightQueensApp());
}

List<List<int>> solveNQueens(int n) {
  List<List<int>> solutions = [];
  List<int> queens = List.filled(n, -1);

  bool isSafe(int row, int col) {
    for (int i = 0; i < row; i++) {
      if (queens[i] == col ||
          queens[i] - col == i - row ||
          queens[i] - col == row - i) {
        return false;
      }
    }
    return true;
  }

  void solve(int row) {
    if (row == n) {
      solutions.add(List.from(queens));
      return;
    }
    for (int col = 0; col < n; col++) {
      if (isSafe(row, col)) {
        queens[row] = col;
        solve(row + 1);
        queens[row] = -1; // Quay lui
      }
    }
  }

  solve(0);
  return solutions;
}

class EightQueensApp extends StatelessWidget {
  const EightQueensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8 Queens Solutions',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: EightQueensPage(),
    );
  }
}

class EightQueensPage extends StatefulWidget {
  const EightQueensPage({super.key});

  @override
  State<EightQueensPage> createState() => _EightQueensPageState();
}

class _EightQueensPageState extends State<EightQueensPage> {
  List<List<int>> solutions = [];
  int currentSolutionIndex = 0;

  @override
  void initState() {
    super.initState();
    solutions = solveNQueens(8);
  }

  void goToNextSolution() {
    setState(() {
      currentSolutionIndex = (currentSolutionIndex + 1) % solutions.length;
    });
  }

  void goToPreviousSolution() {
    setState(() {
      currentSolutionIndex =
          (currentSolutionIndex - 1 + solutions.length) % solutions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('8 Queens Solutions'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            goToPreviousSolution();
          } else if (details.primaryVelocity! < 0) {
            goToNextSolution();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Solution ${currentSolutionIndex + 1} of ${solutions.length}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              buildBoard(solutions[currentSolutionIndex]),
              SizedBox(height: 20),
              Text(
                'Swipe left or right to navigate through the solutions.\n'
                'Use the buttons below to move to the next or previous solution.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: goToPreviousSolution,
                    child: Text('Previous'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: goToNextSolution,
                    child: Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoard(List<int> queens) {
    return Column(
      children: List.generate(8, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(8, (col) {
            return Container(
              width: 40,
              height: 40,
              color: (row + col) % 2 == 0 ? Colors.white : Colors.grey,
              child:
                  queens[row] == col
                      ? Image.asset(
                        'assets/images/queen.png', // Đặt hình ảnh quân hậu
                        width: 38,
                        height: 38,
                        color: Colors.black,
                      )
                      : null,
            );
          }),
        );
      }),
    );
  }
}
