import 'package:steps/features/routines/domain/entities/routine.dart';
import 'package:steps/features/routines/data/repositories/routine_repository.dart';

class CreateRoutine {
  final RoutineRepository repository;
  const CreateRoutine(this.repository);

  Future<void> call(Routine routine) async {
    // TODO
  }
}

