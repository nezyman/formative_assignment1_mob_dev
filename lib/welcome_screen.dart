import 'package:flutter/material.dart';
import 'models.dart';
import 'routes.dart';
import 'theme.dart';
import 'widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    }
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          AppSpacing.large, topPadding + 32, AppSpacing.large, 36),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.timer_outlined,
                size: 30, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.medium),
          const Text(
            'SLA Task Tracker',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Know what's due before it's late.",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Log in to your workspace',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.medium),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Work email',
                        hintText: 'you@company.com',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Enter a valid email address';
                        }
                        return null; // null means valid
                      },
                    ),
                    const SizedBox(height: AppSpacing.medium),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.large),

                    ElevatedButton.icon(
                      onPressed: _logIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Log In'),
                    ),
                    const SizedBox(height: AppSpacing.medium),

                    OutlinedButton.icon(
  onPressed: () => Navigator.pushNamed(context, AppRoutes.signUp),
  style: OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
    foregroundColor: AppColors.primary,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)),
  ),
  icon: const Icon(Icons.person_add_alt_1_outlined),
  label: const Text('Create an account'),
),
                    const SizedBox(height: AppSpacing.large),

                    Text('Every task is tracked as:',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.small),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusLabel(status: SlaStatus.onTrack),
                        StatusLabel(status: SlaStatus.atRisk),
                        StatusLabel(status: SlaStatus.overdue),
                        StatusLabel(status: SlaStatus.completed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}