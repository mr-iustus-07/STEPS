import 'package:steps/features/routines/domain/entities/routine.dart';
import 'package:steps/features/routines/data/repositories/routine_repository.dart';

class FetchRoutines {
  final RoutineRepository repository;
  const FetchRoutines(this.repository);

  Future<List<Routine>> call() =>
      repository.getActiveRoutines().then((routines) => routines.cast<Routine>());
}

