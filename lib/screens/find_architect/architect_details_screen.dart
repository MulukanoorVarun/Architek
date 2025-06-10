import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/theme/spacing.dart';

import '../../bloc/architect/architect_bloc.dart';

class ArchitectDetailsScreen extends StatelessWidget {
  final String architectId;

  const ArchitectDetailsScreen({
    super.key,
    required this.architectId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArchitectBloc, ArchitectState>(
      builder: (context, state) {
        if (state is ArchitectDetailsLoaded) {
          final architect = state.architect;
          
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      architect.profileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    architect.name,
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                  Text(
                                    architect.specialization.join(' • '),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 16,
                                    color: AppColors.success[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: AppColors.success[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              '${architect.experience}',
                              'Years Exp.',
                            ),
                            _buildStatItem(
                              context,
                              '${architect.portfolio.length}',
                              'Projects',
                            ),
                            _buildStatItem(
                              context,
                              '${(architect.rating * 20).round()}%',
                              'Response',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(architect.about),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Portfolio',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: architect.portfolio.length,
                            itemBuilder: (context, index) {
                              final project = architect.portfolio[index];
                              return Container(
                                width: 200,
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(project.images.first),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...architect.testimonials.map((testimonial) => Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      testimonial.clientName,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          index < testimonial.rating.round()
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(testimonial.content),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to chat or contact form
                },
                child: const Text('Contact Architect'),
              ),
            ),
          );
        }
        
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary[700],
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}