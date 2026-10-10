enum Priority { low, medium, high }

enum TaskStatus { todo, inProgress, done }

class Task {
  final String id;
  String title;
  String description;
  String assignee;
  Priority priority;
  DateTime deadline;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.priority,
    required this.deadline,
    this.status = TaskStatus.todo,
  });

  // Task -> Map 
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'assignee': assignee,
        'priority': priority.name,
        'deadline': deadline.toIso8601String(),
        'status': status.name,
      };

  // Map -> Task 
  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        assignee: map['assignee'],
        priority: Priority.values.byName(map['priority']),
        deadline: DateTime.parse(map['deadline']),
        status: TaskStatus.values.byName(map['status']),
      );
}