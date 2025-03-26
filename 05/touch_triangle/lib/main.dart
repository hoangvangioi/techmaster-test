import 'package:flutter/material.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const TouchTriangleApp());
}

class TouchTriangleApp extends StatelessWidget {
  const TouchTriangleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TouchTriangle(title: 'Flutter Touch Triangle'),
    );
  }
}

class TouchTriangle extends StatefulWidget {
  const TouchTriangle({super.key, required this.title});

  final String title;

  @override
  State<TouchTriangle> createState() => _TouchTriangleState();
}

class _TouchTriangleState extends State<TouchTriangle> {
  List<Offset> points =
      []; // Lưu tọa độ của các điểm chạm (3 điểm cho tam giác)
  int? selectedPointIndex; // Theo dõi đỉnh nào được chọn để di chuyển
  bool isTriangleDrawn = false; // Kiểm tra xem tam giác đã được vẽ chưa

  // Hàm để xóa tam giác và làm lại
  void resetTriangle() {
    setState(() {
      points.clear();
      isTriangleDrawn = false; // Đặt lại trạng thái tam giác
    });
  }

  // Hàm kiểm tra xem điểm chạm mới có trùng với điểm nào không
  bool isPointCloseToOthers(Offset newPoint) {
    for (var point in points) {
      if ((point - newPoint).distance < 20) {
        return true; // Nếu điểm mới quá gần các điểm đã có, thì không thêm
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Touch Triangle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetTriangle, // Xóa tam giác và làm lại
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          // Kiểm tra xem người dùng có chạm vào một điểm nào không
          if (isTriangleDrawn) {
            for (int i = 0; i < points.length; i++) {
              if ((points[i] - details.localPosition).distance < 20) {
                setState(
                  () => selectedPointIndex = i,
                  // Đánh dấu điểm đang được di chuyển
                );
              }
            }
          }
        },

        onPanEnd: (details) {
          // Kết thúc kéo: Bỏ chọn đỉnh
          setState(() => selectedPointIndex = null);
        },

        onPanUpdate: (details) {
          // Cập nhật điểm khi người dùng di chuyển
          if (selectedPointIndex != null) {
            setState(() {
              final newPosition = details.localPosition;
              // Kiểm tra xem vị trí mới có trùng với bất kỳ điểm nào khác không
              if (!isPointCloseToOthers(newPosition)) {
                points[selectedPointIndex!] = newPosition;
              }
            });
          }
        },

        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            setState(() {
              if (points.length < 3 && !isTriangleDrawn) {
                // Chỉ thêm điểm nếu tam giác chưa đủ 3 điểm
                if (!isPointCloseToOthers(event.localPosition)) {
                  points.add(
                    event.localPosition,
                  ); // Thêm điểm mới vào danh sách
                }
              }

              // Khi có đủ 3 điểm, đánh dấu tam giác đã được vẽ
              if (points.length == 3 && !isTriangleDrawn) {
                isTriangleDrawn = true;
              }
            });
          },

          onPointerMove: (PointerMoveEvent event) {
            // Cập nhật vị trí của điểm khi ngón tay di chuyển
            if (selectedPointIndex != null) {
              setState(() {
                points[selectedPointIndex!] = event.localPosition;
              });
            }
          },

          onPointerUp: (PointerUpEvent event) {
            setState(() {
              if (Platform.isAndroid || Platform.isIOS) {
                // Nếu chưa đủ 3 điểm để vẽ tam giác thì xóa hết các điểm đã chạm
                if (points.length < 3) {
                  points.clear(); // Xóa tất cả các điểm
                }
              }
            });
          },

          child: CustomPaint(
            size: Size.infinite,
            painter: TrianglePainter(
              points,
              isTriangleDrawn,
              selectedPointIndex, // Truyền chỉ số đỉnh đang di chuyển vào
            ),
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final List<Offset> points;
  final bool isTriangleDrawn;
  final int? selectedPointIndex;

  TrianglePainter(this.points, this.isTriangleDrawn, this.selectedPointIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pointPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    final Paint trianglePaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;

    // Vẽ các đỉnh tam giác
    for (int i = 0; i < points.length; i++) {
      // Đổi màu và kích thước khi hover vào hoặc chọn điểm
      Color pointColor = Colors.red;
      double pointSize = 15.0;

      if (selectedPointIndex == i) {
        pointColor = Colors.yellow; // Đổi màu khi đang di chuyển
        pointSize = 20.0; // Phóng to khi đang di chuyển
      }

      canvas.drawCircle(points[i], pointSize, pointPaint..color = pointColor);
    }

    // Vẽ tam giác nếu đủ 3 điểm
    if (points.length == 3) {
      final Path path =
          Path()
            ..moveTo(points[0].dx, points[0].dy)
            ..lineTo(points[1].dx, points[1].dy)
            ..lineTo(points[2].dx, points[2].dy)
            ..close();
      canvas.drawPath(path, trianglePaint); // Vẽ tam giác
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
