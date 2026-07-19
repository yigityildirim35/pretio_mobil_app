import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class MonthlyBudgetRing extends StatelessWidget {
  final double spent;
  final double monthlyLimit;

  const MonthlyBudgetRing({
    super.key,
    required this.spent,
    required this.monthlyLimit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = Provider.of<CurrencyProvider>(context).currency;

    // 3-layer progress logic (same as BudgetRing)
    double greenProgress = (spent / monthlyLimit).clamp(0.0, 1.0);

    double orangeProgress = 0.0;
    if (spent > monthlyLimit) {
      orangeProgress = ((spent - monthlyLimit) / (0.5 * monthlyLimit)).clamp(
        0.0,
        1.0,
      );
    }

    double redProgress = 0.0;
    if (spent > monthlyLimit * 1.5) {
      redProgress = ((spent - 1.5 * monthlyLimit) / (1.5 * monthlyLimit)).clamp(
        0.0,
        1.0,
      );
    }

    // Color based on severity
    Color accentColor;
    if (spent <= monthlyLimit) {
      accentColor = Theme.of(context).colorScheme.primary;
    } else if (spent < (monthlyLimit * 1.5)) {
      accentColor = Colors.orange;
    } else {
      accentColor = Colors.red;
    }

    final pct = monthlyLimit > 0 ? ((spent / monthlyLimit) * 100).toInt() : 0;
    final remaining = monthlyLimit - spent;

    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Full circle painter
            CustomPaint(
              size: const Size(200, 200),
              painter: _FullCircleLayeredPainter(
                greenProgress: greenProgress,
                orangeProgress: orangeProgress,
                redProgress: redProgress,
                backgroundColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]!
                    : Colors.grey[200]!,
                primaryColor: theme.colorScheme.primary,
              ),
            ),
            // Center text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  remaining >= 0 ? 'Kalan' : 'Aşım',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${remaining.abs().toInt()}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: remaining >= 0
                              ? theme.colorScheme.onSurface
                              : accentColor,
                        ),
                      ),
                      TextSpan(
                        text: ' $currency',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Percentage badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '%$pct',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FullCircleLayeredPainter extends CustomPainter {
  final double greenProgress;
  final double orangeProgress;
  final double redProgress;
  final Color backgroundColor;
  final Color primaryColor;

  _FullCircleLayeredPainter({
    required this.greenProgress,
    required this.orangeProgress,
    required this.redProgress,
    required this.backgroundColor,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 16.0;

    // Background track (full 360°)
    final bgPaint = Paint()
      ..color = backgroundColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2, // Start at top
      2 * math.pi, // Full circle
      false,
      bgPaint,
    );

    // Helper to draw a layer
    void drawLayer(double progress, Color color) {
      if (progress <= 0) return;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -math.pi / 2, // Start from top
        2 * math.pi * progress, // Sweep proportional to progress
        false,
        paint,
      );
    }

    // Draw layers (bottom to top)
    drawLayer(greenProgress, primaryColor);
    drawLayer(orangeProgress, Colors.orange);
    drawLayer(redProgress, Colors.red);
  }

  @override
  bool shouldRepaint(covariant _FullCircleLayeredPainter oldDelegate) {
    return oldDelegate.greenProgress != greenProgress ||
        oldDelegate.orangeProgress != orangeProgress ||
        oldDelegate.redProgress != redProgress;
  }
}
