import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/extensions/context_extensions.dart';

import '../providers/routine_provider.dart';
import '../../data/models/routine_model.dart';
import '../widgets/create_routine_modal.dart'; 

extension TimeFormatExtension on int {
  String get toAMPM {
    final int h = this ~/ 60;
    final int m = this % 60;
    final String ampm = h >= 12 ? 'PM' : 'AM';
    final int displayHour = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final String displayMinute = m.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $ampm';
  }
}

class RoutinesPage extends ConsumerWidget {
  const RoutinesPage({super.key});

  void _openCreateModal(BuildContext context, {RoutineModel? routine}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent, 
      builder: (context) => CreateRoutineModal(existingRoutine: routine),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesState = ref.watch(activeRoutinesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 80.0, floating: true, pinned: true, backgroundColor: AppColors.background.withOpacity(0.95), surfaceTintColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(left: AppSizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DAILY PROTOCOLS', style: context.textTheme.labelSmall?.copyWith(color: AppColors.accent, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                  AppSizes.gapV4,
                  Text('ROUTINES', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),

          routinesState.when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppColors.accent))),
            error: (err, _) => SliverFillRemaining(child: Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error)))),
            data: (routines) {
              if (routines.isEmpty) {
                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p24),
                    child: EmptyState(
                      icon: AppIcons.navRoutines, title: 'NO ACTIVE PROTOCOLS',
                      message: 'Discipline equals freedom. Establish your daily routines to build unstoppable momentum.',
                      actionLabel: 'CREATE ROUTINE', onActionTap: () => _openCreateModal(context),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(AppSizes.p24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final routine = routines[index];
                      final isDone = routine.isCompletedToday;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.p16),
                        child: AppCard(
                          isHighlighted: isDone,
                          padding: const EdgeInsets.all(AppSizes.p20),
                          onTap: () => ref.read(activeRoutinesProvider.notifier).toggleRoutine(routine.id),
                          child: Row(
                            children: [
                              Container(
                                height: 32, width: 32,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: isDone ? AppColors.textPrimary : Colors.transparent, border: Border.all(color: isDone ? AppColors.textPrimary : AppColors.border, width: 2), boxShadow: isDone ? [BoxShadow(color: AppColors.textPrimary.withOpacity(0.3), blurRadius: 8)] : null),
                                child: isDone ? const Icon(Icons.check, size: 18, color: AppColors.background) : null,
                              ),
                              AppSizes.gapH24,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(routine.title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: isDone ? AppColors.textDisabled : AppColors.textPrimary, decoration: isDone ? TextDecoration.lineThrough : null)),
                                    AppSizes.gapV8,
                                    Row(
                                      children: [
                                        const Icon(AppIcons.streakFire, size: 14, color: AppColors.accent),
                                        AppSizes.gapH4,
                                        Text('STREAK: ${routine.currentStreak}', style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                                        if (routine.targetTimeInMinutes != null) ...[
                                          AppSizes.gapH12,
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.surfaceHighlight.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                                            child: Row(children: [const Icon(Icons.access_time, size: 12, color: AppColors.textDisabled), AppSizes.gapH4, Text(routine.targetTimeInMinutes!.toAMPM, style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 10))]),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary), color: AppColors.surfaceHighlight,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), side: const BorderSide(color: AppColors.border)),
                                onSelected: (value) { if (value == 'edit') _openCreateModal(context, routine: routine); },
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: 'edit', child: Text('EDIT', style: context.textTheme.labelLarge?.copyWith(color: AppColors.textPrimary))),
                                  PopupMenuItem(value: 'delete', child: Text('DELETE', style: context.textTheme.labelLarge?.copyWith(color: AppColors.error))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: routines.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateModal(context), backgroundColor: AppColors.accent, foregroundColor: AppColors.background, elevation: 4, icon: const Icon(AppIcons.add),
        label: Text('NEW PROTOCOL', style: context.textTheme.labelLarge?.copyWith(color: AppColors.background, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }
}