import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double strokeWidth;
  final Color color;

  const CustomCircularProgressIndicator({
    super.key,
    this.strokeWidth = 10.0,
    this.color = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;

  _CircularProgressPainter({required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5 * 3.14,
      1.5 * 3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
