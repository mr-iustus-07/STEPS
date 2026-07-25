import 'package:isar/isar.dart';

part 'routine_model.g.dart';

@collection
class RoutineModel {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  String? description;

  /// Target execution time (e.g., 6:00 AM). 
  /// Stored as minutes from midnight (0 - 1439) for ultra-fast database sorting.
  int? targetTimeInMinutes;

  /// 32-bit ID used to cancel/update scheduled flutter_local_notifications
  int? notificationId;
  
  /// 🔥 NEW: Array of active days (1 = Monday, 7 = Sunday)
  List<int> repeatDays = [1, 2, 3, 4, 5, 6, 7]; 

  // --- Streak Tracking Engine ---
  int currentStreak = 0;
  int longestStreak = 0;

  @Index()
  DateTime? lastCompletedDate;

  // --- State & Metadata ---
  @Index()
  bool isActive = true; // False if user archives/pauses the protocol

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// Helper to check if routine is completed today without needing UI logic
  @ignore
  bool get isCompletedToday {
    if (lastCompletedDate == null) return false;
    final now = DateTime.now();
    return lastCompletedDate!.year == now.year &&
           lastCompletedDate!.month == now.month &&
           lastCompletedDate!.day == now.day;
  }
}