import 'package:isar/isar.dart';

part 'task_model.g.dart';

enum TaskPriority { low, medium, high, urgent }

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  late String title;
  
  String? description;

  /// Optional deadline. Indexed because the Dashboard will query "Upcoming Deadlines".
  @Index()
  DateTime? dueDate;

  @enumerated
  TaskPriority priority = TaskPriority.medium;

  // --- State ---
  /// Indexed because "Hide Completed Tasks" is the most common database filter.
  @Index()
  bool isCompleted = false;

  DateTime? completedAt;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  /// Helper for UI styling
  @ignore
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}