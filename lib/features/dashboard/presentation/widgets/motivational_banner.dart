import 'package:flutter/material.dart';

class MotivationalBanner extends StatelessWidget {
  const MotivationalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Small steps every day — you got this!',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

