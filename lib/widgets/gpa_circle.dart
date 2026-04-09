import 'package:flutter/material.dart';
import 'dart:math' as math;

class GPACircle extends StatelessWidget {
  final double gpa;

  const GPACircle({
    super.key,
    required this.gpa,
  });

  Color _getGPAColor() {
    if (gpa >= 3.7) {
      return const Color(0xFF10B981);
    } else if (gpa >= 3.3) {
      return const Color(0xFF2DD4BF);
    } else if (gpa >= 3.0) {
      return const Color(0xFF3B82F6);
    } else if (gpa >= 2.5) {
      return const Color(0xFFF59E0B);
    } else if (gpa >= 2.0) {
      return const Color(0xFFEF4444);
    } else {
      return const Color(0xFF991B1B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (gpa / 4.0).clamp(0.0, 1.0);
    final color = _getGPAColor();

    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: CustomPaint(
          painter: GPACirclePainter(
            percentage: percentage,
            color: color,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  gpa.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current GPA',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GPACirclePainter extends CustomPainter {
  final double percentage;
  final Color color;

  GPACirclePainter({
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(GPACirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
