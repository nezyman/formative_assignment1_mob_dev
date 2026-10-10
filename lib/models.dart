import 'package:flutter/material.dart';
import 'theme.dart';

/// A person in the team.
class TeamMember {
  final String id;
  final String name;
  final String role;

  const TeamMember({required this.id, required this.name, required this.role});

  /// First letters of the name, e.g. "Alice Kim" -> "AK"
  String get initials {
    final parts = name.split(' ');
    return parts.map((p) => p[0]).take(2).join().toUpperCase();
  }
}

/// A task shared by the task, dashboard, SLA, and storage features.
class Task {
  final String id;
  String title;
  String description;
  String assignedTo;
  String priority; // 'Low', 'Medium', 'High'
  DateTime deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.assignedTo,
    this.priority = 'Medium',
    required this.deadline,
    this.isCompleted = false,
  });

  /// Converts a Task object into data that can be encoded as JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'priority': priority,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// Recreates a Task object from previously saved JSON data.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      assignedTo: json['assignedTo'] as String,
      priority: json['priority'] as String? ?? 'Medium',
      deadline: DateTime.parse(json['deadline'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

/// The four SLA statuses. Person 3 decides WHEN a task gets each one.
/// Person 1 decides how each one LOOKS (label, colour, icon).
enum SlaStatus { onTrack, atRisk, overdue, completed }

extension SlaStatusStyle on SlaStatus {
  String get label {
    switch (this) {
      case SlaStatus.onTrack:
        return 'On Track';
      case SlaStatus.atRisk:
        return 'At Risk';
      case SlaStatus.overdue:
        return 'Overdue';
      case SlaStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case SlaStatus.onTrack:
        return AppColors.onTrack;
      case SlaStatus.atRisk:
        return AppColors.atRisk;
      case SlaStatus.overdue:
        return AppColors.overdue;
      case SlaStatus.completed:
        return AppColors.completed;
    }
  }

  IconData get icon {
    switch (this) {
      case SlaStatus.onTrack:
        return Icons.check_circle_outline;
      case SlaStatus.atRisk:
        return Icons.warning_amber_rounded;
      case SlaStatus.overdue:
        return Icons.error_outline;
      case SlaStatus.completed:
        return Icons.task_alt;
    }
  }
}
