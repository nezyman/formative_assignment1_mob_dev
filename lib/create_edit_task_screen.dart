import 'package:flutter/material.dart';
import 'models.dart';
import 'sample_data.dart';

class CreateEditTaskScreen extends StatefulWidget {
  const CreateEditTaskScreen({super.key});

  @override
  State<CreateEditTaskScreen> createState() => _CreateEditTaskScreenState();
}

class _CreateEditTaskScreenState extends State<CreateEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedMember;
  String _selectedPriority = 'Medium';
  DateTime? _selectedDeadline;
  bool _isCompleted = false;

  Task? _editingTask;
  bool _loadedTask = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedTask) return;

    _editingTask =
        ModalRoute.of(context)!.settings.arguments as Task?;

    if (_editingTask != null) {
      _titleController.text = _editingTask!.title;
      _descriptionController.text = _editingTask!.description;
      _selectedMember = _editingTask!.assignedTo;
      _selectedPriority = _editingTask!.priority;
      _selectedDeadline = _editingTask!.deadline;
      _isCompleted = _editingTask!.isCompleted;
    }

    _loadedTask = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = pickedDate;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a deadline.'),
        ),
      );
      return;
    }

    final task = Task(
      id: _editingTask?.id ??
          'T-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      assignedTo: _selectedMember!,
      priority: _selectedPriority,
      deadline: _selectedDeadline!,
      isCompleted: _isCompleted,
    );

    Navigator.pop(context, task);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingTask != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Task' : 'Create Task',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Task title is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the task',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedMember,
              decoration: const InputDecoration(
                labelText: 'Assign to',
                border: OutlineInputBorder(),
              ),
              items: sampleMembers.map((member) {
                return DropdownMenuItem<String>(
                  value: member.name,
                  child: Text(member.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMember = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a team member';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Low',
                  child: Text('Low'),
                ),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: 'High',
                  child: Text('High'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedPriority = value;
                });
              },
            ),

            const SizedBox(height: 16),

            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDeadline == null
                          ? 'No deadline selected'
                          : _formatDate(_selectedDeadline!),
                    ),
                  ),
                  TextButton(
                    onPressed: _selectDeadline,
                    child: const Text('Choose date'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value;
                });
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: Text(
                  isEditing ? 'Save Changes' : 'Create Task',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}