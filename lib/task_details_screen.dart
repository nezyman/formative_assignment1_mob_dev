import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'sla_helper.dart';
import 'widgets.dart';

/// PLACEHOLDER - Person 2 builds the full Task Details screen.
class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the task passed in Navigator.pushNamed(arguments: ...)
    final task = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.taskEdit,
              arguments: task, // sending a task = edit mode
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            StatusLabel(status: calculateSla(task)),
            const SizedBox(height: 12),
            Text(task.description.isEmpty ? 'No description' : task.description),
          ],
        ),
      ),
    );
  }
}