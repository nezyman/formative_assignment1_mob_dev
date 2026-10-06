import 'package:flutter/material.dart';
import 'create_edit_task_screen.dart';
import 'main_shell.dart';
import 'sign_in_screen.dart';
import 'task_details_screen.dart';

/// Every screen name in one place.
class AppRoutes {
  static const signIn = '/';
  static const home = '/home';
  static const taskDetails = '/task-details';
  static const taskEdit = '/task-edit'; // used for Create AND Edit

  static final Map<String, WidgetBuilder> routes = {
    signIn: (context) => const SignInScreen(),
    home: (context) => const MainShell(),
    taskDetails: (context) => const TaskDetailsScreen(),
    taskEdit: (context) => const CreateEditTaskScreen(),
  };
}