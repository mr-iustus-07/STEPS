import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// You will uncomment these as we build the feature models
import '../../features/tasks/data/models/task_model.dart';
import '../../features/routines/data/models/routine_model.dart';
import '../../features/streaks/data/models/streak_model.dart';
/// Riverpod Provider to inject the Isar instance into your repositories.
/// This prevents tight coupling and makes unit testing easier.
final databaseProvider = Provider<Isar>((ref) {
  return DatabaseService.instance;
});

class DatabaseService {
  DatabaseService._(); // Prevent instantiation

  static late final Isar _isar;

  /// Synchronous getter for the active Isar instance.
  /// Safe to call anywhere because `main.dart` awaits `init()` before running the app.
  static Isar get instance => _isar;

  /// Initializes the Isar database.
  static Future<void> init() async {
    try {
      // 1. Locate the safe local directory for the device (iOS/Android)
      final dir = await getApplicationDocumentsDirectory();

      // 2. Open the Isar Database
      _isar = await Isar.open(
        [
          // We will register your generated Schemas here:
          TaskModelSchema,
          RoutineModelSchema,
          StreakModelSchema,
        ],
        directory: dir.path,
        name: 'steps_mission_control_db',
        inspector: true, // Enables the Isar Web Inspector for debugging your data
      );

      log('System DB Online: ${dir.path}', name: 'DatabaseService');
    } catch (e, stackTrace) {
      log('Critical DB Failure', error: e, stackTrace: stackTrace, name: 'DatabaseService');
      // Rethrowing ensures main.dart runZonedGuarded catches it and prevents a silent hang
      rethrow; 
    }
  }

  /// Closes the connection. Useful for complete system resets or testing.
  static Future<void> close() async {
    final isOpen = Isar.getInstance('steps_mission_control_db')?.isOpen ?? false;
    if (isOpen) {
      await _isar.close();
      log('System DB Offline', name: 'DatabaseService');
    }
  }

  /// Wipes all data. 
  /// Essential for your V1 testing phase when schemas change frequently.
  static Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
    log('System DB Wiped - All collections cleared', name: 'DatabaseService');
  }
}