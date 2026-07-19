import 'package:flutter/material.dart';

class AnimatedAmount extends ImplicitlyAnimatedWidget {
  final double amount;
  final String Function(double)? formatter;
  final TextStyle? style;

  const AnimatedAmount({
    super.key,
    required this.amount,
    this.formatter,
    this.style,
    super.duration = const Duration(milliseconds: 1000),
    super.curve = Curves.easeOutCubic,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedAmount> createState() =>
      _AnimatedAmountState();
}

class _AnimatedAmountState extends AnimatedWidgetBaseState<AnimatedAmount> {
  Tween<double>? _amountTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _amountTween =
        visitor(
              _amountTween,
              widget.amount,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final value = _amountTween?.evaluate(animation) ?? widget.amount;
    final String formattedText = widget.formatter != null
        ? widget.formatter!(value)
        : value.toStringAsFixed(2);
    return Text(formattedText, style: widget.style);
  }
}
