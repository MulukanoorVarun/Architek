import 'package:arkitek_app/screens/home_screen.dart';
import 'package:arkitek_app/screens/profile_screen.dart';
import 'package:arkitek_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:arkitek_app/theme/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for each navigation tab
  static final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display screen based on selected index
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          _onItemTapped(index, context);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(AppRoutes.postProject);
        },
        backgroundColor: Colors.blue, // Replace with AppColors.primary[700] if defined
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    // Update the route to keep URL in sync for deep-linking
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.findArchitect);
        break;
      case 2:
        context.go(AppRoutes.profile);
        break;
    }
  }

  // Update selected index when route changes (e.g., deep-linking or back navigation)
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.findArchitect) ||
        location.startsWith(AppRoutes.architectsList) ||
        location.startsWith(AppRoutes.architectDetails)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.profile) || location.startsWith(AppRoutes.settings)) {
      return 2;
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update _selectedIndex when route changes (e.g., via deep-linking)
    final newIndex = _calculateSelectedIndex(context);
    if (_selectedIndex != newIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }
}