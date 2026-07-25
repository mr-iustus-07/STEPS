import 'package:isar/isar.dart';

part 'streak_model.g.dart';

enum StreakTier { standard, superStreak, godTier }

@collection
class StreakModel {
  Id id = Isar.autoIncrement;

  /// Foreign key referencing the RoutineModel's ID.
  /// Indexed because we will look up "All milestones for Routine X".
  @Index()
  late int routineId; 

  late String routineTitleSnapshot; // In case the routine is ever deleted, we keep the record

  /// The exact milestone unlocked (e.g., 7, 30, 100)
  late int milestoneReached;

  @enumerated
  StreakTier tier = StreakTier.standard;

  /// When this milestone was unlocked
  DateTime achievedAt = DateTime.now();
  
  /// Optional reward string or JSON if you implement a reward system later
  String? rewardClaimed; 
}