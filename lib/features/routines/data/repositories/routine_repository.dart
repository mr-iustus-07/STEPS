import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../core/services/database_service.dart';
import '../../../../core/utils/streak_utils.dart';
import '../models/routine_model.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.read(databaseProvider));
});

class RoutineRepository {
  final Isar _isar;

  RoutineRepository(this._isar);

  /// Gets all un-archived routines
  Future<List<RoutineModel>> getActiveRoutines() async {
    return await _isar.routineModels
        .filter()
        .isActiveEqualTo(true)
        .sortByTargetTimeInMinutes()
        .findAll();
  }

  Future<int> saveRoutine(RoutineModel routine) async {
    return await _isar.writeTxn(() async {
      routine.updatedAt = DateTime.now();
      return await _isar.routineModels.put(routine);
    });
  }

  /// Handles the complex streak calculation when a routine is tapped
  Future<void> markRoutineCompleted(int routineId) async {
    await _isar.writeTxn(() async {
      final routine = await _isar.routineModels.get(routineId);
      if (routine != null) {
        final now = DateTime.now();
        
        // Calculate new streak using our pure utility function
        routine.currentStreak = StreakUtils.calculateNewStreak(
          now: now,
          lastCompletedDate: routine.lastCompletedDate,
          currentStreak: routine.currentStreak,
        );

        // Update high score
        if (routine.currentStreak > routine.longestStreak) {
          routine.longestStreak = routine.currentStreak;
        }

        routine.lastCompletedDate = now;
        routine.updatedAt = now;
        
        await _isar.routineModels.put(routine);
      }
    });
  }
}