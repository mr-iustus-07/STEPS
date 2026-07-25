import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  const DashboardState();
}

final dashboardProvider = Provider<DashboardState>((ref) {
  return const DashboardState();
});

