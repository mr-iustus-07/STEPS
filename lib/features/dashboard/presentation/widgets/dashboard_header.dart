import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome back',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

