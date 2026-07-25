import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../data/models/routine_model.dart';

class RoutineProgress extends StatelessWidget {
  final List<RoutineModel> routines;

  const RoutineProgress({
    super.key,
    required this.routines,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<DateTime> last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    final int maxStreak = routines.isEmpty ? 0 : routines.map((r) => r.currentStreak).reduce(math.max);
    final int totalRoutines = routines.length;
    final int completedToday = routines.where((r) => r.isCompletedToday).length;
    
    final bool isTodayPerfect = totalRoutines > 0 && completedToday == totalRoutines;
    final bool isTodayPartial = completedToday > 0 && completedToday < totalRoutines;

    return Container(
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 1), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY PROGRESS', 
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text('Done', style: context.textTheme.labelSmall?.copyWith(fontSize: 10, color: AppColors.textDisabled)),
                  const SizedBox(width: 12),
                  const Icon(Icons.circle, size: 8, color: AppColors.surfaceHighlight),
                  const SizedBox(width: 6),
                  Text('Missed', style: context.textTheme.labelSmall?.copyWith(fontSize: 10, color: AppColors.textDisabled)),
                ],
              )
            ],
          ),
          AppSizes.gapV24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: last7Days.map((date) {
              final isToday = date.day == today.day && date.month == today.month;
              final daysAgo = DateTime(today.year, today.month, today.day).difference(DateTime(date.year, date.month, date.day)).inDays;
              
              int status = 0; // 0 = missed, 1 = partial, 2 = perfect
              
              if (isToday) {
                status = isTodayPerfect ? 2 : (isTodayPartial ? 1 : 0);
              } else {
                status = (daysAgo <= maxStreak && daysAgo > 0) ? 2 : 0;
              }
              
              return Column(
                children: [
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isToday ? AppColors.textPrimary : AppColors.textDisabled,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  AppSizes.gapV12,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 32, 
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status == 2 ? AppColors.textPrimary : Colors.transparent,
                      border: Border.all(
                        color: isToday 
                            ? AppColors.accent // Highlight ring for today
                            : (status == 2 ? AppColors.textPrimary : AppColors.border),
                        width: isToday ? 2 : 1,
                      ),
                      boxShadow: status == 2 ? [
                        BoxShadow(color: AppColors.textPrimary.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)
                      ] : null,
                    ),
                    child: status == 2
                        ? const Icon(Icons.check, size: 16, color: AppColors.background)
                        : (status == 1 
                            ? Center(child: Container(height: 8, width: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.textPrimary.withOpacity(0.5)))) 
                            : null),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}