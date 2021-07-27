import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';

class TopicCurve extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xFFffe2e2);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(size.width / 2, size.height * 1.1, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}