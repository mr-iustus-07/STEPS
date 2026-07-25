import 'package:steps/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> fetchDashboard();
}

