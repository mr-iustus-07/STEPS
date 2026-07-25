import 'package:steps/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:steps/features/dashboard/domain/repositories/dashboard_repository.dart';

class FetchDashboard {
  final DashboardRepository repository;
  const FetchDashboard(this.repository);

  Future<DashboardEntity> call() => repository.fetchDashboard();
}

