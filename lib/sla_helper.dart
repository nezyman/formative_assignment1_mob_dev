import 'models.dart';

SlaStatus calculateSla(Task task) {
  if (task.isCompleted) {
    return SlaStatus.completed;
  }

  final now = DateTime.now();

  if (task.deadline.isBefore(now)) {
    return SlaStatus.overdue;
  }

  final difference = task.deadline.difference(now);

  if (difference <= const Duration(days: 2)) {
    return SlaStatus.atRisk;
  }

  return SlaStatus.onTrack;
}