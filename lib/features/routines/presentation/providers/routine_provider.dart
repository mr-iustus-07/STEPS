import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/routine_model.dart';
import '../../data/repositories/routine_repository.dart';

final activeRoutinesProvider = AsyncNotifierProvider<ActiveRoutinesNotifier, List<RoutineModel>>(
  () => ActiveRoutinesNotifier(),
);

class ActiveRoutinesNotifier extends AsyncNotifier<List<RoutineModel>> {
  late final RoutineRepository _repository;

  @override
  FutureOr<List<RoutineModel>> build() async {
    _repository = ref.read(routineRepositoryProvider);
    return _fetchAndValidateRoutines();
  }

  /// Fetches routines and validates active streak states
  Future<List<RoutineModel>> _fetchAndValidateRoutines() async {
    final routines = await _repository.getActiveRoutines();
    final now = DateTime.now();
    bool dbUpdated = false;

    for (var routine in routines) {
      if (routine.lastCompletedDate == null) continue;

      final lastDate = routine.lastCompletedDate!;
      final isToday = lastDate.year == now.year && 
                      lastDate.month == now.month && 
                      lastDate.day == now.day;
                      
      final yesterday = now.subtract(const Duration(days: 1));
      final isYesterday = lastDate.year == yesterday.year && 
                          lastDate.month == yesterday.month && 
                          lastDate.day == yesterday.day;

      // STREAK BREAKER: If missed yesterday AND today, reset the streak
      if (!isToday && !isYesterday && routine.currentStreak > 0) {
        routine.currentStreak = 0;
        await _repository.saveRoutine(routine); 
        dbUpdated = true;
      }
    }

    return dbUpdated ? await _repository.getActiveRoutines() : routines;
  }

  Future<void> addRoutine(RoutineModel routine) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveRoutine(routine);
      return _fetchAndValidateRoutines();
    });
  }

  /// 🔥 SILENT TOGGLE ENGINE: Instant feedback loop with zero UI freeze
  Future<void> toggleRoutine(int routineId) async {
    final currentList = state.valueOrNull ?? [];
    
    // Optimistic compilation update for immediate local frame rendering
    final updatedList = currentList.map((r) {
      if (r.id == routineId) {
        final now = DateTime.now();
        if (r.isCompletedToday) {
          r.currentStreak = r.currentStreak > 0 ? r.currentStreak - 1 : 0;
          r.lastCompletedDate = now.subtract(const Duration(days: 1));
        } else {
          r.lastCompletedDate = now;
          r.currentStreak += 1;
          if (r.currentStreak > r.longestStreak) {
            r.longestStreak = r.currentStreak;
          }
        }
      }
      return r;
    }).toList();

    // Force Riverpod to render the visual modification immediately 
    state = AsyncValue.data(updatedList);

    // Persist to underlying Isar storage silently in the background thread
    try {
      final targetRoutine = updatedList.firstWhere((r) => r.id == routineId);
      await _repository.saveRoutine(targetRoutine);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteRoutine(int routineId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Assuming delete routine exists in your repository framework
      // await _repository.deleteRoutine(routineId);
      return _fetchAndValidateRoutines();
    });
  }
}