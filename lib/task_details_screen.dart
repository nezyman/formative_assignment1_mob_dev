import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'sla_helper.dart';
import 'widgets.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit task',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.taskEdit,
                arguments: task,
              );

              if (result is Task && context.mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            task.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 12),

          StatusLabel(
            status: calculateSla(task),
          ),

          const SizedBox(height: 24),

          _DetailRow(
            icon: Icons.person_outline,
            label: 'Assigned to',
            value: task.assignedTo,
          ),

          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.flag_outlined,
            label: 'Priority',
            value: task.priority,
          ),

          const SizedBox(height: 16),

          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Deadline',
            value: _formatDate(task.deadline),
          ),

          const SizedBox(height: 24),

          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(
              task.description.isEmpty
                  ? 'No description provided.'
                  : task.description,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Icon(Icons.task_alt),
              const SizedBox(width: 8),
              Text(
                task.isCompleted ? 'Completed' : 'Not completed',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}