import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'sample_data.dart';

/// Saves and loads the task list on the device.
///
/// SharedPreferences stores simple values, so the task list is converted to
/// JSON before saving and converted back into Task objects when loading.
class TaskStorage {
  static const String _tasksKey = 'saved_tasks';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<Task>> loadTasks() async {
    final savedJson = await _preferences.getString(_tasksKey);

    // First launch: seed the app with the starter tasks once, then persist them.
    if (savedJson == null) {
      final initialTasks = sampleTasks();
      await saveTasks(initialTasks);
      return initialTasks;
    }

    try {
      final decoded = jsonDecode(savedJson) as List<dynamic>;
      return decoded
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // If saved data cannot be decoded, restore a usable starter list.
      final fallbackTasks = sampleTasks();
      await saveTasks(fallbackTasks);
      return fallbackTasks;
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await _preferences.setString(_tasksKey, encoded);
  }
}
