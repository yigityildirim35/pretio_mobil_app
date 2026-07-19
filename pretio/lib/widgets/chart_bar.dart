import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double heightPct;
  final Color color;
  final bool isSelected;
  final double maxBarHeight; // New parameter

  const ChartBar({
    super.key,
    required this.label,
    required this.heightPct,
    required this.color,
    this.isSelected = false,
    this.maxBarHeight = 120.0, // Default for backward compatibility
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 10,
          height: maxBarHeight * heightPct,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(color: theme.canvasColor, shape: BoxShape.circle)
              : null,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  final Color primaryColor;
  ChartPainter(this.primaryColor);
  @override
  void paint(Canvas canvas, Size size) {
    final paintGreen = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final paintPurple = Paint()
      ..color = Colors.purpleAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final pathGreen = Path();
    pathGreen.moveTo(0, size.height * 0.8);
    pathGreen.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.3,
    );
    pathGreen.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.2,
      size.width,
      size.height * 0.5,
    );
    final pathPurple = Path();
    pathPurple.moveTo(0, size.height * 0.5);
    pathPurple.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.5,
    );
    pathPurple.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.3,
      size.width,
      size.height * 0.6,
    );
    canvas.drawPath(pathGreen, paintGreen);
    canvas.drawPath(pathPurple, paintPurple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
