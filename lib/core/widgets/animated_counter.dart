import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // Tweening from 0 ensures a cool count-up effect on initial load
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      // easeOutCubic starts fast and slows down precisely at the target number
      curve: Curves.easeOutCubic, 
      builder: (context, val, child) {
        return Text(
          '$prefix${val.toInt()}$suffix',
          style: style ?? Theme.of(context).textTheme.displayLarge,
        );
      },
    );
  }
}