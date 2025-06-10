import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/architect/architect_bloc.dart';

class ArchitectListScreen extends StatefulWidget {
  final String location;

  const ArchitectListScreen({super.key, required this.location});

  @override
  State<ArchitectListScreen> createState() => _ArchitectListScreenState();
}

class _ArchitectListScreenState extends State<ArchitectListScreen> {
  int _currentTabIndex = 1; // Default to Find Architect tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: Text('Architects in ${widget.location}'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.findArchitect),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options (future implementation)
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ArchitectBloc, ArchitectState>(
          builder: (context, state) {
            if (state is ArchitectsLoading) {
              return FadeIn(
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is ArchitectsLoaded && state.architects.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.architects.length,
                itemBuilder: (context, index) {
                  final architect = state.architects[index];
                  return SlideInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(architect.profileImage),
                          backgroundColor: AppColors.primary[100],
                        ),
                        title: Text(
                          architect.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              architect.specialization.join(', '),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                Text(' ${architect.rating}'),
                                Text(' • Est. ${architect.experience} years'),
                              ],
                            ),
                            Text('${architect.location.city}, ${architect.location.state}'),
                          ],
                        ),
                        onTap: () {
                          context.read<ArchitectBloc>().add(LoadArchitectDetails(architect.id));
                          context.go(AppRoutes.architectDetails.replaceAll(':id', architect.id));
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              // Handle ArchitectsLoaded with empty list or ArchitectsError
              return FadeIn(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1749213060037.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No architects found in ${widget.location}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.secondary[600],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.findArchitect),
                        child: Text(
                          'Try Another Location',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),

    );
  }
}