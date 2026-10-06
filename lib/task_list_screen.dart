import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'sample_data.dart';
import 'theme.dart';
import 'widgets.dart';

/// Shows sample tasks so navigation can be tested.
/// Person 2 will expand this with real data.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = sampleTasks();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.medium),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          // Open Task Details and send the chosen task along
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.taskDetails,
            arguments: task,
          ),
        );
      },
    );
  }
}