import 'package:flutter/material.dart';
import 'routes.dart';
import 'task_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved tasks before the first screen is shown.
  await taskStore.load();

  runApp(const TaskTrackerApp());
}

/// Root widget of the app. It sets the theme and the named routes.
class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLA Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.signIn,
      routes: AppRoutes.routes,
    );
  }
}
