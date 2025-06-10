import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

import '../../bloc/architect/architect_bloc.dart';

class FindArchitectScreen extends StatefulWidget {
  const FindArchitectScreen({super.key});

  @override
  State<FindArchitectScreen> createState() => _FindArchitectScreenState();
}

class _FindArchitectScreenState extends State<FindArchitectScreen> {
  String? selectedState;
  String? selectedCity;
  int _currentTabIndex = 1; // Default to Find Architect tab

  final List<String> states = [
    'California',
    'New York',
    'Texas',
    'Florida',
    'Illinois'
  ];

  final Map<String, List<String>> cities = {
    'California': ['San Francisco', 'Los Angeles', 'San Diego'],
    'New York': ['New York City', 'Buffalo', 'Albany'],
    'Texas': ['Houston', 'Austin', 'Dallas'],
    'Florida': ['Miami', 'Orlando', 'Tampa'],
    'Illinois': ['Chicago', 'Springfield', 'Aurora']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: const Text('Find My Architect'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeIn(
                child: Image.network(
                  'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg',
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FadeInLeft(
                child: Text(
                  'State',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                child: DropdownButtonFormField<String>(
                  value: selectedState,
                  decoration: InputDecoration(
                    hintText: 'Select a state',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  items: states.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                      selectedCity = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'City',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                child: DropdownButtonFormField<String>(
                  value: selectedCity,
                  decoration: InputDecoration(
                    hintText: selectedState == null ? 'Select a state first' : 'Select a city',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                  items: selectedState == null
                      ? []
                      : cities[selectedState]!.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: selectedState == null
                      ? null
                      : (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SlideInUp(
                child: ElevatedButton.icon(
                  onPressed: selectedCity != null
                      ? () {
                    context.read<ArchitectBloc>().add(
                      SearchArchitects('$selectedCity, $selectedState'),
                    );
                    context.go(
                      AppRoutes.architectsList,
                      extra: {
                        'location': '$selectedCity, $selectedState',
                      },
                    );
                  }
                      : null,
                  icon: const Icon(Icons.search),
                  label: const Text('Find Architects'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}