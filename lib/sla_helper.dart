import 'models.dart';

/// TEMPORARY version so the task cards work.
/// Person 3 will replace this with the final SLA rules.
SlaStatus calculateSla(Task task) {
  if (task.isCompleted) return SlaStatus.completed;
  if (task.deadline.isBefore(DateTime.now())) return SlaStatus.overdue;
  final daysLeft = task.deadline.difference(DateTime.now()).inDays;
  if (daysLeft <= 2) return SlaStatus.atRisk;
  return SlaStatus.onTrack;
}