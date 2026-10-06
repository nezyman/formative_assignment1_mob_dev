import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'models.dart';
import 'routes.dart';
import 'task_list_screen.dart';
import 'team_screen.dart';

/// The main frame of the app: top bar + bottom navigation bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _titles = ['Dashboard', 'Tasks', 'Team'];

  // Teammates replace these placeholder screens with their own.
  final _pages = const [DashboardScreen(), TaskListScreen(), TeamScreen()];

  @override
  Widget build(BuildContext context) {
    // The user chosen on the Sign In screen
    final user = ModalRoute.of(context)!.settings.arguments as TeamMember?;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Switch user',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.signIn),
          ),
        ],
      ),
      body: Column(
        children: [
          if (user != null)
            Container(
              width: double.infinity,
              color: const Color(0xFFE8EAF6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Signed in as ${user.name} (${user.role})',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          Expanded(
            // IndexedStack keeps all pages alive; only one is visible
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
        ],
      ),
      // "+" button only on the Tasks tab
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.taskEdit),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard'),
          NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'Tasks'),
          NavigationDestination(
              icon: Icon(Icons.group_outlined),
              selectedIcon: Icon(Icons.group),
              label: 'Team'),
        ],
      ),
    );
  }
}