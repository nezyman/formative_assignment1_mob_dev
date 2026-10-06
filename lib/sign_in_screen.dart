import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'sample_data.dart';
import 'theme.dart';

/// Screen 1: the user picks who they are (no real login needed).
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TeamMember? _selected; // null until the user taps a member

  void _continue() {
    // Replaces Sign In so the Back button doesn't return to it
    Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.large),
              const Icon(Icons.checklist_rtl_rounded,
                  size: 56, color: AppColors.primary),
              const SizedBox(height: AppSpacing.medium),
              Text('SLA Task Tracker',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.small),
              Text('Choose your profile to continue',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.large),
              Expanded(
                child: ListView.builder(
                  itemCount: sampleMembers.length,
                  itemBuilder: (context, index) {
                    final member = sampleMembers[index];
                    final isSelected = _selected?.id == member.id;
                    return Card(
                      color: isSelected ? const Color(0xFFE8EAF6) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(member.initials,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(member.name),
                        subtitle: Text(member.role),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle,
                                color: AppColors.primary)
                            : null,
                        onTap: () => setState(() => _selected = member),
                      ),
                    );
                  },
                ),
              ),
              // Disabled (onPressed: null) until someone is chosen
              ElevatedButton(
                onPressed: _selected == null ? null : _continue,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}