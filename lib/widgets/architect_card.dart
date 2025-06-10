import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:arkitek_app/models/architect.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';

class ArchitectCard extends StatelessWidget {
  final Architect? architect;
  final VoidCallback onTap;
  final VoidCallback? onMapFocus;
  final bool isHorizontal;

  const ArchitectCard({
    super.key,
    this.architect,
    required this.onTap,
    this.onMapFocus,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (architect == null) {
      return _buildPlaceholder(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isHorizontal
            ? _buildHorizontalCard(context)
            : _buildVerticalCard(context),
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: architect!.profileImage.isNotEmpty
                  ? Image.network(
                      architect!.profileImage,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.secondary[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.secondary[700],
                      ),
                    ),
            ),
            if (onMapFocus != null)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.center_focus_strong,
                    color: Colors.white,
                  ),
                  onPressed: onMapFocus,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary[700]!.withOpacity(0.7),
                  ),
                ),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                architect!.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: architect!.rating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(${architect!.rating.toStringAsFixed(1)})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                '${architect!.location.city}, ${architect!.location.state}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: architect!.specialization
                    .take(2)
                    .map(
                      (spec) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          spec,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary[700],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          child: architect!.profileImage.isNotEmpty
              ? Image.network(
                  architect!.profileImage,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: AppColors.secondary[300],
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.secondary[700],
                  ),
                ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  architect!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: architect!.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(${architect!.rating.toStringAsFixed(1)})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${architect!.location.city}, ${architect!.location.state}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: architect!.specialization
                      .take(2)
                      .map(
                        (spec) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            spec,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary[700],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${architect!.experience}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary[700],
                ),
              ),
              Text(
                'years',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary[100],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}