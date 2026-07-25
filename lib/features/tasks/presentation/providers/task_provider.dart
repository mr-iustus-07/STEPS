import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

// Note: Keeping the name 'pendingTasksProvider' so your Dashboard Page doesn't break!
final pendingTasksProvider = AsyncNotifierProvider<TasksNotifier, List<TaskModel>>(
  () => TasksNotifier(),
);

class TasksNotifier extends AsyncNotifier<List<TaskModel>> {
  late final TaskRepository _repository;

  @override
  FutureOr<List<TaskModel>> build() async {
    _repository = ref.read(taskRepositoryProvider);
    return _fetchTasks();
  }

  Future<List<TaskModel>> _fetchTasks() async {
    return await _repository.getAllTasks();
  }

  Future<void> addTask(TaskModel task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.saveTask(task);
      return _fetchTasks();
    });
  }

  Future<void> toggleTask(int taskId) async {
    try {
      await _repository.toggleCompletion(taskId);
      // 🔥 Await the re-fetch so Riverpod automatically re-sorts the list
      state = AsyncValue.data(await _fetchTasks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(int taskId) async {
    state = await AsyncValue.guard(() async {
      await _repository.deleteTask(taskId);
      return _fetchTasks();
    });
  }
}