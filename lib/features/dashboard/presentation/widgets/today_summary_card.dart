import 'package:flutter/material.dart';

import '../providers/dashboard_provider.dart';

class TodaySummaryCard extends StatelessWidget {
  final DashboardState state;
  const TodaySummaryCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Today Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Summary coming soon...'),
          ],
        ),
      ),
    );
  }
}

