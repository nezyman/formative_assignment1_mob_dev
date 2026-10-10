import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'sample_data.dart';
import 'theme.dart';
import 'widgets.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = sampleTasks();
  }

  Future<void> _createTask() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.taskEdit,
    );

    if (result is Task) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  Future<void> _openTaskDetails(Task task) async {
  final result = await Navigator.pushNamed(
    context,
    AppRoutes.taskDetails,
    arguments: task,
  );

  if (result is Task) {
    setState(() {
      final index = _tasks.indexWhere(
        (item) => item.id == result.id,
      );

      if (index != -1) {
        _tasks[index] = result;
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text('No tasks yet. Tap + to create one.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.medium),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return TaskCard(
                  task: task,
                  onTap: () => _openTaskDetails(task),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}