import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/animated_counter.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../data/models/routine_model.dart';

class RoutineCard extends StatelessWidget {
  final RoutineModel routine;
  final VoidCallback? onTap;

  const RoutineCard({
    super.key,
    required this.routine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = routine.isCompletedToday;

    return AppCard(
      isHighlighted: isDone,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.streakFire, 
            color: isDone ? AppColors.textPrimary : AppColors.textDisabled, 
            size: 28,
          ),
          AppSizes.gapV8,
          AnimatedCounter(
            value: routine.currentStreak,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold, 
              color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          AppSizes.gapV4,
          Text(
            routine.title.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDone ? AppColors.textPrimary : AppColors.textDisabled, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}