import 'models.dart';

SlaStatus calculateSla(Task task) {
  if (task.isCompleted) return SlaStatus.completed;
  if (task.deadline.isBefore(DateTime.now())) return SlaStatus.overdue;
  final daysLeft = task.deadline.difference(DateTime.now()).inDays;
  if (daysLeft <= 2) return SlaStatus.atRisk;
  return SlaStatus.onTrack;
}