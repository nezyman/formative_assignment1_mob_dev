import 'package:flutter/material.dart';
import 'models.dart';
import 'sla_helper.dart';
import 'theme.dart';

/// Small rounded badge showing an SLA status (icon + text + colour).
class StatusLabel extends StatelessWidget {
  final SlaStatus status;
  const StatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable card that shows one task.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final status = calculateSla(task);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: status.color, width: 5)),
          ),
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(task.title,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  StatusLabel(status: status),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(task.assignedTo)),
                  const Icon(Icons.flag_outlined,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(task.priority),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text('Due ${_formatDate(task.deadline)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}