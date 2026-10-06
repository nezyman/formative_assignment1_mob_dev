import 'package:flutter/foundation.dart';

import 'models.dart';
import 'sample_data.dart';
import 'task_storage.dart';

/// One shared in-memory task list for the whole app.
///
/// Screens read from this store. When a task changes, the store saves the
/// complete list locally and notifies listening widgets to rebuild.
class TaskStore extends ChangeNotifier {
  TaskStore({TaskStorage? storage}) : _storage = storage ?? TaskStorage();

  final TaskStorage _storage;
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> load() async {
    final savedTasks = await _storage.loadTasks();
    _tasks
      ..clear()
      ..addAll(savedTasks);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveAndRefresh();
  }

  Future<bool> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index == -1) return false;

    _tasks[index] = updatedTask;
    await _saveAndRefresh();
    return true;
  }

  Future<bool> deleteTask(String taskId) async {
    final originalLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == taskId);

    if (_tasks.length == originalLength) return false;

    await _saveAndRefresh();
    return true;
  }

  Future<bool> setTaskCompletion(String taskId, bool isCompleted) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return false;

    _tasks[index].isCompleted = isCompleted;
    await _saveAndRefresh();
    return true;
  }

  List<Task> tasksForMember(String memberName) {
    final normalizedName = memberName.trim().toLowerCase();
    return _tasks
        .where(
          (task) => task.assignedTo.trim().toLowerCase() == normalizedName,
        )
        .toList();
  }

  Future<void> resetToSampleTasks() async {
    _tasks
      ..clear()
      ..addAll(sampleTasks());
    await _saveAndRefresh();
  }

  Future<void> _saveAndRefresh() async {
    await _storage.saveTasks(_tasks);
    notifyListeners();
  }
}

/// Shared instance used by the current small assignment app.
final taskStore = TaskStore();
