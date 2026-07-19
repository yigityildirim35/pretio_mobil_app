import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:pretio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';

class BudgetRing extends StatelessWidget {
  final double remaining;
  final double goal;
  final VoidCallback onGoalTap;

  const BudgetRing({
    super.key,
    required this.remaining,
    required this.goal,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spent = goal - remaining;
    final is3DEnabled = Provider.of<ThemeProvider>(context).is3DEnabled;

    // Logic 1: Safe Zone (Green) - 0 to Goal
    double greenProgress = (spent / goal).clamp(0.0, 1.0);

    // Logic 2: Warning Zone (Orange) - Goal to 1.5x Goal
    double orangeProgress = 0.0;
    if (spent > goal) {
      orangeProgress = ((spent - goal) / (0.5 * goal)).clamp(0.0, 1.0);
    }

    // Logic 3: Critical Zone (Red) - 1.5x Goal to 3.0x Goal
    double redProgress = 0.0;
    if (spent > goal * 1.5) {
      redProgress = ((spent - 1.5 * goal) / (1.5 * goal)).clamp(0.0, 1.0);
    }

    // Determine the text color based on the highest severity level reached
    Color textColor;
    if (spent <= goal) {
      textColor = theme.colorScheme.primary;
    } else if (spent < (goal * 1.5)) {
      textColor = theme.colorScheme.tertiary; // Warning (e.g. Amber/Orange)
    } else {
      textColor = theme.colorScheme.error; // Critical (e.g. Pinkish Red)
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 280,
            height: 140, // Half height for half circle
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomPaint(
                  size: const Size(280, 140),
                  painter: _HalfCircleLayeredPainter(
                    greenProgress: greenProgress,
                    orangeProgress: orangeProgress,
                    redProgress: redProgress,
                    backgroundColor: theme.canvasColor,
                    primaryColor: theme.colorScheme.primary,
                    warningColor: theme.colorScheme.tertiary, // dynamic
                    errorColor: theme.colorScheme.error, // dynamic
                    is3DEnabled: is3DEnabled,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.remaining,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: Provider.of<CurrencyProvider>(context)
                                    .getDisplayValue(remaining, compact: true)
                                    .replaceAll(
                                      RegExp(r'[^\d.,kM-]'),
                                      '',
                                    ), // Show only number/k/M here
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: remaining < 0
                                    ? textColor
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' ${Provider.of<CurrencyProvider>(context).currency}', // Space + Currency
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: onGoalTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: textColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.goal(0).replaceAll('0', '')}${Provider.of<CurrencyProvider>(context).getDisplayValue(goal, compact: true)}',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.edit, size: 12, color: textColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfCircleLayeredPainter extends CustomPainter {
  final double greenProgress;
  final double orangeProgress;
  final double redProgress;
  final Color backgroundColor;
  final Color primaryColor;
  final Color warningColor;
  final Color errorColor;
  final bool is3DEnabled;

  _HalfCircleLayeredPainter({
    required this.greenProgress,
    required this.orangeProgress,
    required this.redProgress,
    required this.backgroundColor,
    required this.primaryColor,
    required this.warningColor,
    required this.errorColor,
    required this.is3DEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    // Background Track (180 degrees)
    // From PI to 2*PI (or PI, sweeping PI)
    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi, // Start at left (180 deg)
      math.pi, // Sweep 180 deg to right
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
        math.pi, // Always start from left
        math.pi * progress, // Sweep proportional to progress (max 180 deg)
        false,
        paint,
      );

      // 3D glow effect removed as per user request
    }

    // Draw Layers using the logic: Overlays
    // 1. Green (Bottom layer)
    drawLayer(greenProgress, primaryColor);

    // 2. Orange (Middle layer)
    drawLayer(orangeProgress, warningColor);

    // 3. Red (Top layer)
    drawLayer(redProgress, errorColor);
  }

  @override
  bool shouldRepaint(covariant _HalfCircleLayeredPainter oldDelegate) {
    return oldDelegate.greenProgress != greenProgress ||
        oldDelegate.orangeProgress != orangeProgress ||
        oldDelegate.redProgress != redProgress ||
        oldDelegate.is3DEnabled != is3DEnabled;
  }
}
