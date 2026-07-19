import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedLayeredGauge extends StatefulWidget {
  final double spent;
  final double dailyGoal;
  final int dayNumber;
  final bool isToday;
  final VoidCallback? onTap;

  const AnimatedLayeredGauge({
    super.key,
    required this.spent,
    required this.dailyGoal,
    required this.dayNumber,
    this.isToday = false,
    this.onTap,
  });

  @override
  State<AnimatedLayeredGauge> createState() => _AnimatedLayeredGaugeState();
}

class _AnimatedLayeredGaugeState extends State<AnimatedLayeredGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldRatio = 0.0;

  double get _targetRatio {
    if (widget.dailyGoal <= 0) return 0.0;
    return widget.spent / widget.dailyGoal;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _oldRatio = _targetRatio;
    _animation = AlwaysStoppedAnimation(_oldRatio);
    if (_oldRatio > 0) {
      _animation = Tween<double>(begin: 0.0, end: _oldRatio).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedLayeredGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newRatio = _targetRatio;
    if ((newRatio - _oldRatio).abs() > 0.001) {
      _animation = Tween<double>(begin: _oldRatio, end: newRatio).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
      _oldRatio = newRatio;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: LayeredGaugePainter(
              spendingRatio: _animation.value,
              isToday: widget.isToday,
              isDark: theme.brightness == Brightness.dark,
              primaryColor: theme.colorScheme.primary,
              warningColor: theme.colorScheme.tertiary,
              errorColor: theme.colorScheme.error,
            ),
            child: child,
          );
        },
        child: Center(
          child: Text(
            '${widget.dayNumber}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: widget.isToday ? FontWeight.w900 : FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class LayeredGaugePainter extends CustomPainter {
  final double spendingRatio;
  final bool isToday;
  final bool isDark;
  final Color primaryColor;
  final Color warningColor;
  final Color errorColor;

  LayeredGaugePainter({
    required this.spendingRatio,
    required this.isToday,
    required this.isDark,
    required this.primaryColor,
    required this.warningColor,
    required this.errorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (min(size.width, size.height) / 2) - 0.5;
    const strokeWidth = 5.0; // Slightly thicker
    final arcRadius = outerRadius - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: arcRadius);
    const startAngle = -pi / 2;
    const fullSweep = 2 * pi;

    if (spendingRatio <= 0) return;

    // Background track
    final trackPaint = Paint()
      ..color = (isDark ? Colors.grey[800]! : Colors.grey[300]!).withValues(
        alpha: 0.35,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, arcRadius, trackPaint);

    // Tier 1: Safe Zone (0 → 100%)
    final greenProgress = spendingRatio.clamp(0.0, 1.0);

    // Tier 2: Warning Zone (100% → 150%)
    double orangeProgress = 0.0;
    if (spendingRatio > 1.0) {
      orangeProgress = ((spendingRatio - 1.0) / 0.5).clamp(0.0, 1.0);
    }

    // Tier 3: Critical Zone (150%+)
    double redProgress = 0.0;
    if (spendingRatio > 1.5) {
      redProgress = ((spendingRatio - 1.5) / 1.5).clamp(0.0, 1.0);
    }

    // Draw layers bottom → top
    _drawArc(canvas, rect, startAngle, fullSweep * greenProgress, primaryColor);

    if (orangeProgress > 0) {
      _drawArc(
        canvas,
        rect,
        startAngle,
        fullSweep * orangeProgress,
        warningColor,
      );
    }

    if (redProgress > 0) {
      _drawArc(canvas, rect, startAngle, fullSweep * redProgress, errorColor);
    }
  }

  void _drawArc(
    Canvas canvas,
    Rect rect,
    double start,
    double sweep,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, start, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant LayeredGaugePainter oldDelegate) {
    return oldDelegate.spendingRatio != spendingRatio ||
        oldDelegate.isToday != isToday ||
        oldDelegate.isDark != isDark;
  }
}
