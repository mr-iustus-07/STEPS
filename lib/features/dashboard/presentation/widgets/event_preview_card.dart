import 'package:flutter/material.dart';

class EventPreviewCard extends StatelessWidget {
  const EventPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Event preview coming soon...'),
      ),
    );
  }
}

