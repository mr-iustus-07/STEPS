import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../core/services/database_service.dart';
import '../models/task_model.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(databaseProvider));
});

class TaskRepository {
  final Isar _isar;
  TaskRepository(this._isar);

  /// Fetches ALL tasks, but sorts completed ones to the absolute bottom.
  Future<List<TaskModel>> getAllTasks() async {
    final tasks = await _isar.taskModels.where().findAll();
    
    // In-memory sort ensures perfect ordering without complex Isar indexing
    tasks.sort((a, b) {
      // 1. Pending tasks above Completed tasks
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      // 2. Highest priority first
      if (a.priority != b.priority) return b.priority.index.compareTo(a.priority.index);
      // 3. Closest deadline first
      if (a.dueDate == null && b.dueDate != null) return 1;
      if (a.dueDate != null && b.dueDate == null) return -1;
      if (a.dueDate != null && b.dueDate != null) return a.dueDate!.compareTo(b.dueDate!);
      return 0;
    });
    
    return tasks;
  }

  Future<int> saveTask(TaskModel task) async {
    return await _isar.writeTxn(() async {
      task.updatedAt = DateTime.now();
      return await _isar.taskModels.put(task);
    });
  }

  Future<void> toggleCompletion(int taskId) async {
    await _isar.writeTxn(() async {
      final task = await _isar.taskModels.get(taskId);
      if (task != null) {
        task.isCompleted = !task.isCompleted;
        task.completedAt = task.isCompleted ? DateTime.now() : null;
        task.updatedAt = DateTime.now();
        await _isar.taskModels.put(task);
      }
    });
  }

  Future<void> deleteTask(int taskId) async {
    await _isar.writeTxn(() async {
      await _isar.taskModels.delete(taskId);
    });
  }
}