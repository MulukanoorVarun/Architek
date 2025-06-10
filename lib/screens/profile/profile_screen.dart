import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/blocs/auth/auth_bloc.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentTabIndex = 0; // Profile doesn't have a tab, so default to Home

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: const Text('My Profile'),
        ),
        actions: [
          ZoomIn(
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                context.go(AppRoutes.settings);
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return FadeIn(
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeIn(
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary[100],
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user.profileImage == null
                                ? Text(
                              user.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary[700],
                              ),
                            )
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.secondary[700],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Chip(
                            label: Text(
                              user.userType == 'client' ? 'Client Account' : 'Architect Account',
                            ),
                            backgroundColor: user.userType == 'client'
                                ? AppColors.primary[100]
                                : AppColors.accent[100],
                            labelStyle: TextStyle(
                              color: user.userType == 'client'
                                  ? AppColors.primary[700]
                                  : AppColors.accent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FadeInLeft(child: _buildStatsSection(context, user)),
                  const SizedBox(height: AppSpacing.lg),
                  FadeInLeft(child: _buildAccountSection(context)),
                  const SizedBox(height: AppSpacing.lg),
                  if (user.userType == 'client')
                    FadeInRight(child: _buildClientSection(context))
                  else
                    FadeInRight(child: _buildArchitectSection(context)),
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
            );
          } else {
            return FadeIn(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 80,
                      color: AppColors.secondary[400],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to login (implement route)
                      },
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () {
                        // Navigate to register (implement route)
                      },
                      child: const Text('Create an Account'),
                    ),
                  ],
                ),
              ),
            );
          }
        },


      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Projects',
                  user.projects?.length.toString() ?? '0',
                  Icons.business_center_outlined,
                ),
                _buildStatItem(
                  context,
                  'Saved',
                  user.savedArchitects?.length.toString() ?? '0',
                  Icons.bookmark_outline,
                ),
                _buildStatItem(
                  context,
                  'Messages',
                  '0', // Placeholder
                  Icons.chat_bubble_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary[700],
            size: 30,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Account Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
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
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notification settings (implement route)
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClientSection(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Client Tools',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Create New Project'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {

            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('Saved Architects'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to saved architects (implement route)
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Project History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to project history (implement route)
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArchitectSection(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Architect Tools',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text('Manage Portfolio'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to portfolio management (implement route)
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Project Proposals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to project proposals (implement route)
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Client Reviews'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to reviews (implement route)
            },
          ),
        ],
      ),
    );
  }
}