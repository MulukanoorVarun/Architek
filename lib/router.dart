import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:tripfin/Screens/Views/VacationHistory.dart';
import 'package:tripfin/Screens/Views/HomeScreen.dart';
import 'package:tripfin/Screens/Views/Splash.dart';
import 'package:tripfin/Screens/Views/profile_screen.dart';
import 'Screens/Authentication/Login_Screen.dart';
import 'Screens/Authentication/RegisterScreen.dart';
import 'Screens/Views/EditProfileScreen.dart';
import 'Screens/Views/Onboardscreen.dart';
import 'Screens/Views/OutOfBudgetScreen.dart';
import 'Screens/Views/PerfectScreen.dart';
import 'Screens/Views/UpdateExpenceScreen.dart';
import 'main.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(Splash(), state),
    ),
    GoRoute(
      path: '/on_board',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(Onboardscreen(), state),
    ),
    GoRoute(
      path: '/login_mobile',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(LoginScreen(), state),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(RegisterScreen(), state),
    ),
    GoRoute(
      path: '/home',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(HomeScreen(), state),
    ),
    GoRoute(
      path: '/profile_screen',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(ProfileScreen(), state),
    ),
    GoRoute(
      path: '/perfect_screen',
      pageBuilder:
          (context, state) => buildSlideTransitionPage(PerfectScreen(), state),
    ),
    GoRoute(
      path: '/out_of_theBudget',
      pageBuilder:
          (context, state) =>
              buildSlideTransitionPage(OutOfBudgetScreen(), state),
    ),
    // GoRoute(
    //   path: '/out_of_theBudget',
    //   pageBuilder:
    //       (context, state) => buildSlideTransitionPage(OutOfBudgetScreen(), state),
    // ),
    GoRoute(
      path: '/edit_profile_screen',
      pageBuilder:
          (context, state) =>
              buildSlideTransitionPage(Editprofilescreen(), state),
    ),

    GoRoute(
      path: '/update_expensive',
      pageBuilder: (context, state) {
        final id = state.uri.queryParameters['id'];
        final budget = state.uri.queryParameters['budget'];
        final place = state.uri.queryParameters['place'];
        final expenceId = state.uri.queryParameters['expenseId'];
        return buildSlideTransitionPage(
          UpdateExpense(
            id: id ?? "",
            budget: budget ?? "",
            place: place ?? "",
            expenseId: expenceId ?? "",
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: '/vacation',
      pageBuilder: (context, state) {
        final budget = state.uri.queryParameters['budget'];
        final place = state.uri.queryParameters['place'];
        return buildSlideTransitionPage(
          VacationHistory(budget: budget ?? "", place: place ?? ""),
          state,
        );
      },
    ),
  ],
);

Page<dynamic> buildSlideTransitionPage(Widget child, GoRouterState state) {
  if (Platform.isIOS) {
    return CupertinoPage(key: state.pageKey, child: child);
  }

  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
