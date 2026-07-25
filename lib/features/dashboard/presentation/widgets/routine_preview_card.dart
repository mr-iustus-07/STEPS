import 'package:flutter/material.dart';

class RoutinePreviewCard extends StatelessWidget {
  const RoutinePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Routine preview coming soon...'),
      ),
    );
  }
}

