import 'package:flutter/material.dart';

class TaskPreviewCard extends StatelessWidget {
  const TaskPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Task preview coming soon...'),
      ),
    );
  }
}

