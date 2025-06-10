import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arkitek_app/screens/home/home_screen.dart';
import 'package:arkitek_app/screens/find_architect/find_architect_screen.dart';
import 'package:arkitek_app/screens/find_architect/architect_list_screen.dart';
import 'package:arkitek_app/screens/find_architect/architect_details_screen.dart';
import 'package:arkitek_app/screens/post_project/post_project_screen.dart';
import 'package:arkitek_app/screens/messages/messages_screen.dart';
import 'package:arkitek_app/screens/profile/profile_screen.dart';
import 'package:arkitek_app/screens/auth/register_architect_screen.dart';
import 'package:arkitek_app/screens/main_screen.dart';

import '../screens/Settings/SettingsScreen.dart';

class AppRoutes {
  static const String home = '/';
  static const String findArchitect = '/find-architect';
  static const String architectsList = '/architects-list';
  static const String architectDetails = '/architect/:id';
  static const String postProject = '/post-project';
  static const String registerArchitect = '/register-architect';
  static const String projects = '/projects';
  static const String messages = '/messages';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String projectDetails = '/project/:id';
  static const String chatDetails = '/messages/:id';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.findArchitect,
            builder: (context, state) => const FindArchitectScreen(),
          ),
          GoRoute(
            path: AppRoutes.architectsList,
            builder: (context, state) {
              final location = (state.extra as Map<String, dynamic>)['location'] as String;
              return ArchitectListScreen(location: location);
            },
          ),
          GoRoute(
            path: AppRoutes.architectDetails,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ArchitectDetailsScreen(architectId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.postProject,
            builder: (context, state) => const PostProjectScreen(),
          ),
          GoRoute(
            path: AppRoutes.registerArchitect,
            builder: (context, state) => const RegisterArchitectScreen(),
          ),

          GoRoute(
            path: AppRoutes.messages,
            builder: (context, state) => const MessagesScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}