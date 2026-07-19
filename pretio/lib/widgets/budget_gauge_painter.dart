import 'package:flutter/material.dart';
import 'dart:math' as math;

class BudgetGaugePainter extends CustomPainter {
  final double progressPercent; // 0.0 to 1.0 for normal budget
  final bool isOverBudget;
  final Color primaryColor;
  final Color backgroundColor;

  BudgetGaugePainter({
    required this.progressPercent,
    required this.isOverBudget,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;

    // Background arc (grey)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw base background (180 degrees from left)
    canvas.drawArc(rect, math.pi, math.pi, false, bgPaint);

    final sweepAngle = (1.0 - progressPercent.clamp(0.0, 1.0)) * math.pi;

    if (!isOverBudget) {
      // Normal state: paint primary arc
      final fillPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawArc(rect, math.pi, sweepAngle, false, fillPaint);
    } else {
      // Over budget state: full red arc
      final fullFillPaint = Paint()
        ..color = Colors.redAccent
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawArc(rect, math.pi, math.pi, false, fullFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BudgetGaugePainter oldDelegate) {
    return oldDelegate.progressPercent != progressPercent ||
        oldDelegate.isOverBudget != isOverBudget ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
