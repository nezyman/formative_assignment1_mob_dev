import 'package:flutter/material.dart';
import 'models.dart';

class CreateEditTaskScreen extends StatelessWidget {
  const CreateEditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task?;
    final isEditing = task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Create Task')),
      body: const Center(child: Text('Task form (Person 2)')),
    );
  }
}