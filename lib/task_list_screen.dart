import 'package:flutter/material.dart';

import 'models.dart';
import 'routes.dart';
import 'sla_helper.dart';
import 'task_store.dart';
import 'theme.dart';
import 'widgets.dart';

/// Shows the shared task list.
///
/// Person 4 integration: tasks come from TaskStore so saved changes are shared
/// across Tasks, Team, and Dashboard instead of recreating sample data.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    taskStore.addListener(_refresh);
  }

  @override
  void dispose() {
    taskStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskStore.tasks;
    final completed = tasks.where((task) => task.isCompleted).length;
    final attention = tasks.where((task) {
      final status = calculateSla(task);
      return status == SlaStatus.atRisk || status == SlaStatus.overdue;
    }).length;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      children: [
        _TaskSummary(
          total: tasks.length,
          completed: completed,
          attention: attention,
        ),
        const SizedBox(height: AppSpacing.large),
        Text(
          'Work queue',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Everything currently assigned to the team.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.medium),
        if (tasks.isEmpty)
          const _EmptyTasks()
        else
          ...tasks.map(
            (task) => _TaskListItem(
              task: task,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.taskDetails,
                arguments: task,
              ),
            ),
          ),
      ],
    );
  }
}

class _TaskSummary extends StatelessWidget {
  final int total;
  final int completed;
  final int attention;

  const _TaskSummary({
    required this.total,
    required this.completed,
    required this.attention,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17245C), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Wrap(
        spacing: AppSpacing.large,
        runSpacing: AppSpacing.medium,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TASKS',
                  style: TextStyle(
                    color: Color(0xFFC7D2FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Know what needs attention',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A clear view of progress, deadlines, and ownership.',
                  style: TextStyle(
                    color: Color(0xFFE4E8FF),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              _SummaryMetric(
                icon: Icons.list_alt_outlined,
                value: total,
                label: 'Total',
              ),
              _SummaryMetric(
                icon: Icons.task_alt,
                value: completed,
                label: 'Completed',
              ),
              _SummaryMetric(
                icon: Icons.warning_amber_rounded,
                value: attention,
                label: 'Need attention',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _SummaryMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(238),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const _TaskListItem({required this.task, required this.onTap});

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final status = calculateSla(task);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE3E7F0)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: status.color.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(status.icon, color: status.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        StatusLabel(status: status),
                      ],
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          icon: Icons.person_outline,
                          label: task.assignedTo,
                        ),
                        _MetaChip(
                          icon: Icons.flag_outlined,
                          label: '${task.priority} priority',
                        ),
                        _MetaChip(
                          icon: Icons.calendar_today_outlined,
                          label: 'Due ${_formatDate(task.deadline)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.textGrey),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 36, color: AppColors.textGrey),
          SizedBox(height: 10),
          Text(
            'No tasks yet',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Create a task to start building the team workload.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
