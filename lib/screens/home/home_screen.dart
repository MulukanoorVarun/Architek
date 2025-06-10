import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arkitek_app/widgets/architect_card.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';
import 'package:arkitek_app/routes/app_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../bloc/archeticlist/ArcheticCubit.dart';
import '../../bloc/archeticlist/ArcheticState.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;

  final List<String> _bannerImages = [
    'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg',
    'https://images.pexels.com/photos/1115804/pexels-photo-1115804.jpeg',
    'https://images.pexels.com/photos/1732414/pexels-photo-1732414.jpeg',
  ];

  final List<Map<String, dynamic>> _quickLinks = [
    {
      'title': 'Find Architect',
      'icon': Icons.search,
      'color': AppColors.primary[700],
      'route': AppRoutes.findArchitect,
    },
    {
      'title': 'Post Project',
      'icon': Icons.add_circle_outline,
      'color': AppColors.accent[700],
      'route': AppRoutes.postProject,
    },
    {
      'title': 'My Projects',
      'icon': Icons.business_center_outlined,
      'color': AppColors.secondary[700],
      'route': AppRoutes.projects,
    },
    {
      'title': 'Messages',
      'icon': Icons.chat_bubble_outline,
      'color': AppColors.success[700],
      'route': AppRoutes.messages,
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<ArcheticCubit>().getarchitecture();
    // context.read<ArchitectBloc>().add(LoadFeaturedArchitects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              FadeIn(child: _buildHeroSection()),
              FadeInLeft(child: _buildQuickLinks()),
              FadeInLeft(child: _buildFeaturedArchitects()),
              FadeInRight(child: _buildRecentArchitects()),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ElasticIn(
                child: CircleAvatar(
                  backgroundColor: AppColors.primary[700],
                  radius: 20,
                  child: Text(
                    'A',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              ElasticIn(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Architec',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ZoomIn(
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Navigate to notifications
                  },
                ),
              ),
              ZoomIn(
                delay: const Duration(milliseconds: 100),
                child: IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    context.go(AppRoutes.profile);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        FadeIn(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1.0,
              autoPlay: true,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
            ),
            items: _bannerImages.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeInDown(
                              child: Text(
                                'Connecting visionaries with architects',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            FadeInUp(
                              child: Text(
                                'Find the perfect architect for your dream project',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _bannerImages.asMap().entries.map((entry) {
            return Bounce(
              delay: Duration(milliseconds: 100 * entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBannerIndex == entry.key
                      ? AppColors.primary[700]
                      : AppColors.secondary[300],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickLinks() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInLeft(
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _quickLinks.asMap().entries.map((entry) {
              final link = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: SlideInUp(
                    delay: Duration(milliseconds: 100 * entry.key),
                    child: _buildQuickLinkItem(
                      title: link['title'],
                      icon: link['icon'],
                      color: link['color'],
                      onTap: () {
                        context.go(link['route']);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedArchitects() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInLeft(
                child: Text(
                  'Featured Architects',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                child: TextButton(
                  onPressed: () {
                    context.go(AppRoutes.findArchitect);
                  },
                  child: Text('View All'),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          BlocBuilder<ArcheticCubit, Archeticstate>(
            builder: (context, state) {
              if (state is archeticLoading) {
                return FadeIn(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is archeticLoaded) {
                return SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.architectModel.data?.data?.length,
                    itemBuilder: (context, index) {
                      final data = state.architectModel.data?.data?[index];
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: SlideInLeft(
                          delay: Duration(milliseconds: 100 * index),
                          child: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Stack(
                                //   children: [
                                    // SizedBox(
                                    //   height: 120,
                                    //   width: double.infinity,
                                    //   child: data!..isNotEmpty
                                    //       ? Image.network(
                                    //     architect!.profileImage,
                                    //     fit: BoxFit.cover,
                                    //   )
                                    //       : Container(
                                    //     color: AppColors.secondary[300],
                                    //     child: Icon(
                                    //       Icons.person,
                                    //       size: 50,
                                    //       color: AppColors.secondary[700],
                                    //     ),
                                    //   ),
                                    // ),
                                    // if (onMapFocus != null)
                                    //   Positioned(
                                    //     top: 8,
                                    //     right: 8,
                                    //     child: IconButton(
                                    //       icon: Icon(
                                    //         Icons.center_focus_strong,
                                    //         color: Colors.white,
                                    //       ),
                                    //       onPressed: onMapFocus,
                                    //       style: IconButton.styleFrom(
                                    //         backgroundColor: AppColors.primary[700]!.withOpacity(0.7),
                                    //       ),
                                    //     ),
                                    //   ),
                                //   ],
                                // ),
                                Padding(
                                  padding: EdgeInsets.all(AppSpacing.sm),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.name??"",
                                        style: Theme.of(context).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // SizedBox(height: 2),
                                      // Row(
                                      //   children: [
                                      //     RatingBarIndicator(
                                      //       rating: architect!.rating,
                                      //       itemBuilder: (context, index) => Icon(
                                      //         Icons.star,
                                      //         color: Colors.amber,
                                      //       ),
                                      //       itemCount: 5,
                                      //       itemSize: 14,
                                      //     ),
                                      //     SizedBox(width: 4),
                                      //     Text(
                                      //       '(${architect!.rating.toStringAsFixed(1)})',
                                      //       style: Theme.of(context).textTheme.bodySmall,
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${data?.officeLocation??""}, ${data!.country}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      // SizedBox(height: 4),
                                      // Wrap(
                                      //   spacing: 4,
                                      //   runSpacing: 4,
                                      //   children: architect!.specialization
                                      //       .take(2)
                                      //       .map(
                                      //         (spec) => Container(
                                      //       padding: EdgeInsets.symmetric(
                                      //         horizontal: 6,
                                      //         vertical: 2,
                                      //       ),
                                      //       decoration: BoxDecoration(
                                      //         color: AppColors.primary[100],
                                      //         borderRadius: BorderRadius.circular(4),
                                      //       ),
                                      //       child: Text(
                                      //         spec,
                                      //         style: TextStyle(
                                      //           fontSize: 10,
                                      //           color: AppColors.primary[700],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   )
                                      //       .toList(),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                          ),
                        )));

                    },
                  ),
                );
              } else if (state is archeticError) {
                return FadeIn(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: SlideInLeft(
                          delay: Duration(milliseconds: 100 * index),
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              color: AppColors.secondary[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentArchitects() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                child: Text(
                  'Recently Joined Architects',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              FadeInRight(
                delay: const Duration(milliseconds: 100),
                child: TextButton(
                  onPressed: () {
                    context.go(AppRoutes.findArchitect);
                  },
                  child: Text('View All'),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          // BlocBuilder<ArchitectBloc, ArchitectState>(
          //   builder: (context, state) {
          //     if (state is FeaturedArchitectsLoaded) {
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: state.architects.length,
          //         itemBuilder: (context, index) {
          //           final architect = state.architects[index];
          //           return SlideInUp(
          //             delay: Duration(milliseconds: 100 * index),
          //             child: Card(
          //               margin: EdgeInsets.only(bottom: AppSpacing.md),
          //               child: ListTile(
          //                 leading: CircleAvatar(
          //                   backgroundImage:
          //                       NetworkImage(architect.profileImage),
          //                   radius: 30,
          //                 ),
          //                 title: Text(
          //                   architect.name,
          //                   style: Theme.of(context).textTheme.titleMedium,
          //                 ),
          //                 subtitle: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Icon(Icons.star,
          //                             size: 16, color: Colors.amber),
          //                         Text(' ${architect.rating}'),
          //                         Text(' • ${architect.experience} years exp.'),
          //                       ],
          //                     ),
          //                     Text(
          //                         '${architect.location.city}, ${architect.location.state}'),
          //                     Wrap(
          //                       spacing: 4,
          //                       children: architect.specialization
          //                           .take(2)
          //                           .map((spec) => Chip(
          //                                 label: Text(
          //                                   spec,
          //                                   style: TextStyle(fontSize: 12),
          //                                 ),
          //                                 backgroundColor:
          //                                     AppColors.primary[100],
          //                                 labelStyle: TextStyle(
          //                                   color: AppColors.primary[700],
          //                                 ),
          //                               ))
          //                           .toList(),
          //                     ),
          //                   ],
          //                 ),
          //                 onTap: () {
          //                   context
          //                       .read<ArchitectBloc>()
          //                       .add(LoadArchitectDetails(architect.id));
          //                   context.go(AppRoutes.architectDetails
          //                       .replaceAll(':id', architect.id));
          //                 },
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }
          //     return SizedBox();
          //   },
          // ),

        ],
      ),
    );
  }
}
