import 'package:flutter/material.dart';
import 'models.dart';
import 'sample_data.dart';
import 'sla_helper.dart';
import 'widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = sampleTasks();

    int completed = 0;
    int onTrack = 0;
    int atRisk = 0;
    int overdue = 0;

    for (final task in tasks) {
      switch (calculateSla(task)) {
        case SlaStatus.completed:
          completed++;
          break;
        case SlaStatus.onTrack:
          onTrack++;
          break;
        case SlaStatus.atRisk:
          atRisk++;
          break;
        case SlaStatus.overdue:
          overdue++;
          break;
      }
    }

    final total = tasks.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Overview',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Track your project tasks and SLA status.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _StatCard(
                title: 'Total Tasks',
                value: total.toString(),
                icon: Icons.task_alt,
              ),
              _StatCard(
                title: 'Completed',
                value: completed.toString(),
                icon: SlaStatus.completed.icon,
                color: SlaStatus.completed.color,
              ),
              _StatCard(
                title: 'On Track',
                value: onTrack.toString(),
                icon: SlaStatus.onTrack.icon,
                color: SlaStatus.onTrack.color,
              ),
              _StatCard(
                title: 'At Risk',
                value: atRisk.toString(),
                icon: SlaStatus.atRisk.icon,
                color: SlaStatus.atRisk.color,
              ),
              _StatCard(
                title: 'Overdue',
                value: overdue.toString(),
                icon: SlaStatus.overdue.icon,
                color: SlaStatus.overdue.color,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Project Progress',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${(progress * 100).round()}%'),
                      Text('$completed of $total tasks completed'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Task SLA Status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...tasks.map(
            (task) => TaskCard(task: task),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cardColor.withAlpha(30),
              child: Icon(icon, color: cardColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}