import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

import '../bloc/auth/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentTabIndex = 0; // Default to Home
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: const Text('Settings'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.profile),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInLeft(
                child: Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to edit profile (implement route)
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outlined),
                        title: const Text('Change Password'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to change password (implement route)
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Notification Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                child: Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Push Notifications'),
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() {
                            _pushNotifications = value;
                          });
                          // Save to backend or local storage
                        },
                        activeColor: AppColors.primary[700],
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Email Notifications'),
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() {
                            _emailNotifications = value;
                          });
                          // Save to backend or local storage
                        },
                        activeColor: AppColors.primary[700],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SlideInUp(
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogOut());
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Log Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error[700],
                      side: BorderSide(color: AppColors.error[700]!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),


    );
  }
}