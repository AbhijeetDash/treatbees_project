//Shape Painter
import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  final String shape;
  final double sx, sy;
  Color color = Colors.black;
  ShapePainter({@required this.shape, this.sx, this.sy, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var center = Offset(size.width / 2, size.height / 2);
    var pint = Paint()
      ..shader =
          LinearGradient(colors: [Colors.yellow[800], Colors.yellow[900]])
              .createShader(rect);
    switch (shape) {
      case "rect":
        var rect = Rect.fromLTRB(0, 0, sx, sy);
        canvas.drawRect(rect, pint);
        break;
      case "tri":
        var path = Path();
        path.addPolygon(
            [Offset(sx / 2, 0), Offset(0, sy), Offset(sx, sy)], true);
        canvas.drawPath(path, pint);
        break;
      case "circle":
        var rect = Rect.fromLTRB(0, 0, sx, sy);
        canvas.drawOval(rect, pint);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
