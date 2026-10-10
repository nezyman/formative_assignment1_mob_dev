import 'models.dart';
final List<TeamMember> sampleMembers = [
  TeamMember(id: '1', name: 'Lia Teta', role: 'Project Manager'),
  TeamMember(id: '2', name: 'Brian manzi', role: 'Flutter Developer'),
  TeamMember(id: '3', name: 'phionah Mwiza', role: 'UI Designer'),
  TeamMember(id: '4', name: 'Daniel Neza', role: 'QA Tester'),
];

List<Task> sampleTasks() => [
      Task(
        id: 't1',
        title: 'Design login screen',
        description: 'Create the sign in / user selection screen.',
        assignedTo: 'Phionah Mwiza',
        priority: 'High',
        deadline: DateTime.now().add(const Duration(days: 7)),
      ),
      Task(
        id: 't2',
        title: 'Write SLA rules',
        assignedTo: 'Brian Manzi',
        priority: 'Medium',
        deadline: DateTime.now().add(const Duration(days: 1)),
      ),
      Task(
        id: 't3',
        title: 'Fix navigation bug',
        assignedTo: 'Daniel Neza',
        priority: 'High',
        deadline: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Task(
        id: 't4',
        title: 'Set up GitHub repo',
        assignedTo: 'Lia Teta',
        priority: 'Low',
        deadline: DateTime.now().subtract(const Duration(days: 5)),
        isCompleted: true,
      ),
    ];