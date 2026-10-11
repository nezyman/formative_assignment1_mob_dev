import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Temporary list for testing. In a real app, this would be loaded from a database or API.
  final List<Task> _tasks = [
    Task(
      id: 'T-101',
      title: 'Catalog new book arrivals',
      description: 'Add the 40 new books to the library system',
      assignee: 'Ridaa',
      priority: Priority.high,
      deadline: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      id: 'T-102',
      title: 'Send overdue book reminders',
      description: 'Email students with books past the return date',
      assignee: 'Nada',
      priority: Priority.medium,
      deadline: DateTime.now().add(const Duration(days: 8)),
      status: TaskStatus.inProgress,
    ),
    Task(
      id: 'T-103',
      title: 'Reorganize the reference shelves',
      description: 'Sort by subject and update the shelf labels',
      assignee: 'Aline',
      priority: Priority.low,
      // past deadline on purpose, to test the Overdue status later
      deadline: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String _statusText(TaskStatus s) {
    switch (s) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  // Simple day/month/year
  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    // colored dot shows the priority at a glance
                    leading: CircleAvatar(
                      backgroundColor: _priorityColor(task.priority),
                      radius: 8,
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                      '${task.assignee} • Due ${_formatDate(task.deadline)}',
                    ),
                    trailing: Text(_statusText(task.status)),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}