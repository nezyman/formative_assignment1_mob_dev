import 'package:flutter/material.dart';
import 'create_edit_task_screen.dart';
import 'main_shell.dart';
import 'sign_in_screen.dart';
import 'task_details_screen.dart';
import 'welcome_screen.dart';
import 'sign_up_screen.dart';

class AppRoutes {
  static const welcome = '/';              
  static const signIn = '/user-select';    
  static const home = '/home';
  static const taskDetails = '/task-details';
  static const taskEdit = '/task-edit'; 
  static const signUp = '/sign-up';

  static final Map<String, WidgetBuilder> routes = {
    welcome: (context) => const WelcomeScreen(),
    signIn: (context) => const SignInScreen(),
    home: (context) => const MainShell(),
    taskDetails: (context) => const TaskDetailsScreen(),
    taskEdit: (context) => const CreateEditTaskScreen(),
    signUp: (context) => const SignUpScreen(),
  };
}