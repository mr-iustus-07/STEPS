import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/animated_counter.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';

// Feature Imports
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../routines/presentation/providers/routine_provider.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../routines/data/models/routine_model.dart';
import '../../../routines/presentation/widgets/routine_progress_indicator.dart';

// ============================================================================
// ANIMATION ENGINE: Super Streak & Candle Effects
// ============================================================================
class CelebrationOverlay extends StatefulWidget {
  final CelebrationType type;
  final VoidCallback onComplete;

  const CelebrationOverlay({super.key, required this.type, required this.onComplete});

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

enum CelebrationType { none, candle, superStreak }

class _CelebrationOverlayState extends State<CelebrationOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _scale = Tween<double>(begin: 0.5, end: 1.5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == CelebrationType.none) return const SizedBox.shrink();

    final isSuper = widget.type == CelebrationType.superStreak;
    final color = isSuper ? Colors.amberAccent : AppColors.accent;
    final icon = isSuper ? Icons.local_fire_department : Icons.whatshot;
    final text = isSuper ? 'SUPER STREAK ACTIVATED\nPERFECT DAY!' : '+1 ROUTINE LOGGED';

    return IgnorePointer(
      child: Container(
        color: isSuper ? Colors.black.withOpacity(0.4) : Colors.transparent, 
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.6 * _fade.value),
                              blurRadius: isSuper ? 60 : 30,
                              spreadRadius: isSuper ? 20 : 10,
                            ),
                          ],
                        ),
                        child: Icon(icon, size: isSuper ? 100 : 60, color: color),
                      ),
                      AppSizes.gapV24,
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: [Shadow(color: color, blurRadius: 10)],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD PAGE
// ============================================================================
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  CelebrationType _currentCelebration = CelebrationType.none;

  void _triggerCelebration(bool isPerfectDay) {
    setState(() {
      _currentCelebration = isPerfectDay ? CelebrationType.superStreak : CelebrationType.candle;
    });
  }

  String _getDynamicGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING, CHIEF';
    if (hour < 17) return 'AFTERNOON EXECUTION';
    return 'EVENING REVIEW';
  }

  Widget _buildPriorityPill(TaskPriority priority, BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.urgent:
        bgColor = AppColors.error.withOpacity(0.15);
        textColor = AppColors.error;
        label = 'URGENT';
        break;
      case TaskPriority.high:
        bgColor = AppColors.textPrimary.withOpacity(0.1);
        textColor = AppColors.textPrimary;
        label = 'HIGH';
        break;
      case TaskPriority.medium:
        bgColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        label = 'MED';
        break;
      case TaskPriority.low:
        bgColor = Colors.transparent;
        textColor = AppColors.textDisabled;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: priority == TaskPriority.low ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  // 🔥 HIGH-DENSITY: Now features 3 Core Metrics
  Widget _buildQuickStats(BuildContext context, List<RoutineModel> routines, List<TaskModel> allTasks) {
    int maxStreak = routines.isEmpty ? 0 : routines.map((r) => r.currentStreak).reduce(math.max);
    int completedToday = routines.where((r) => r.isCompletedToday).length;
    int total = routines.isEmpty ? 1 : routines.length; 
    int percentage = ((completedToday / total) * 100).round();
    
    int tasksDoneToday = allTasks.where((t) => t.isCompleted).length;

    if (routines.isEmpty) percentage = 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('COMPLETION', style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
              AppSizes.gapV4,
              Text('$percentage%', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          Column(
            children: [
              Text('BEST STREAK', style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
              AppSizes.gapV4,
              Text('$maxStreak', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.accent)),
            ],
          ),
          Container(width: 1, height: 40, color: AppColors.border),
          Column(
            children: [
              Text('TASKS DONE', style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
              AppSizes.gapV4,
              Text('$tasksDoneToday', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoutinesSection(BuildContext context, AsyncValue<List<RoutineModel>> routinesState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'ROUTINES', icon: AppIcons.navRoutines, actionLabel: 'VIEW ALL', onActionTap: () => context.push('/routines')),
        AppSizes.gapV16,
        routinesState.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
          error: (err, _) => Center(child: Text('DB Error', style: TextStyle(color: AppColors.error))),
          data: (routines) {
            if (routines.isEmpty) {
              return InkWell(
                onTap: () => context.push('/routines'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.p24),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: Column(
                    children: [
                      const Icon(AppIcons.navRoutines, color: AppColors.textDisabled, size: 32),
                      AppSizes.gapV12,
                      Text('No Active Routines', style: context.textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
                      AppSizes.gapV16,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.surfaceHighlight, borderRadius: BorderRadius.circular(20)),
                        child: Text('+ CREATE ROUTINE', style: context.textTheme.labelSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              );
            }
            
            return SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  final bool isDoneToday = routine.isCompletedToday;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.p12),
                    child: SizedBox(
                      width: 130,
                      child: AppCard(
                        isHighlighted: isDoneToday,
                        onTap: isDoneToday ? null : () async {
                          await ref.read(activeRoutinesProvider.notifier).toggleRoutine(routine.id);
                          final allPending = routines.where((r) => !r.isCompletedToday).toList();
                          final isPerfectDay = allPending.length <= 1; 
                          _triggerCelebration(isPerfectDay);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AppIcons.streakFire, color: isDoneToday ? AppColors.textPrimary : AppColors.textDisabled, size: 28),
                            AppSizes.gapV8,
                            AnimatedCounter(
                              value: routine.currentStreak,
                              style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: isDoneToday ? AppColors.textPrimary : AppColors.textSecondary),
                            ),
                            AppSizes.gapV4,
                            Text(
                              routine.title.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelSmall?.copyWith(color: isDoneToday ? AppColors.textPrimary : AppColors.textDisabled, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTasksSection(BuildContext context, AsyncValue<List<TaskModel>> tasksState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'PENDING TASKS', icon: AppIcons.navTasks, actionLabel: 'VIEW BOARD', onActionTap: () => context.push('/tasks')),
        AppSizes.gapV16,
        tasksState.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
          error: (err, _) => const Center(child: Text('DB Error', style: TextStyle(color: AppColors.error))),
          data: (allTasks) {
            final pendingTasks = allTasks.where((t) => !t.isCompleted).toList();

            if (pendingTasks.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.textDisabled, size: 32),
                    AppSizes.gapV12,
                    Text('All Directives Executed', style: context.textTheme.titleSmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingTasks.length > 5 ? 5 : pendingTasks.length,
              itemBuilder: (context, index) {
                final task = pendingTasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.p12),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border, width: 1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(pendingTasksProvider.notifier).toggleTask(task.id);
                          },
                          child: Container(
                            height: 24, width: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, 
                              border: Border.all(color: AppColors.border, width: 2),
                              color: task.isCompleted ? AppColors.textPrimary : Colors.transparent,
                            ),
                            child: task.isCompleted ? const Icon(Icons.check, size: 16, color: AppColors.background) : null,
                          ),
                        ),
                        AppSizes.gapH16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              if (task.dueDate != null) ...[
                                AppSizes.gapV4,
                                Text(task.dueDate!.toRelative.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: task.isOverdue ? AppColors.error : AppColors.textSecondary, fontSize: 10)),
                              ],
                            ],
                          ),
                        ),
                        _buildPriorityPill(task.priority, context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // 🔥 NEW: Fills the dead space in the lower-left column on desktop
  Widget _buildDeepWorkPlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p24),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.center_focus_strong, color: AppColors.textDisabled, size: 20),
              AppSizes.gapH8,
              Text(
                'DEEP WORK SESSIONS', 
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.textDisabled, fontWeight: FontWeight.bold, letterSpacing: 1.5)
              ),
            ],
          ),
          AppSizes.gapV16,
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
              child: Text(
                'Focus module initializing in v1.2...', 
                style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textDisabled, fontStyle: FontStyle.italic)
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routinesState = ref.watch(activeRoutinesProvider);
    final tasksState = ref.watch(pendingTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 90.0,
                floating: true,
                pinned: true,
                backgroundColor: AppColors.background.withOpacity(0.95),
                surfaceTintColor: Colors.transparent,
                title: Padding(
                  padding: const EdgeInsets.only(left: AppSizes.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDynamicGreeting(),
                        style: context.textTheme.labelSmall?.copyWith(color: AppColors.accent, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                      ),
                      AppSizes.gapV4,
                      Text(
                        'DASHBOARD',
                        style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: AppSizes.p24),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24), 
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.accent),
                        AppSizes.gapH8,
                        Text(
                          DateTime.now().toSystemFormat.toUpperCase(),
                          style: context.textTheme.labelMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final routinesData = routinesState.valueOrNull ?? [];
                      final allTasksData = tasksState.valueOrNull ?? [];
                      
                      if (constraints.maxWidth > 800) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RoutineProgress(routines: routinesData),
                                  AppSizes.gapV32,
                                  _buildRoutinesSection(context, routinesState),
                                  AppSizes.gapV32,
                                  _buildDeepWorkPlaceholder(context), // Fills the dead space
                                ],
                              ),
                            ),
                            AppSizes.gapH32,
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildQuickStats(context, routinesData, allTasksData),
                                  AppSizes.gapV32,
                                  _buildTasksSection(context, tasksState),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoutineProgress(routines: routinesData),
                          AppSizes.gapV24,
                          _buildQuickStats(context, routinesData, allTasksData),
                          AppSizes.gapV32,
                          _buildRoutinesSection(context, routinesState),
                          AppSizes.gapV32,
                          _buildTasksSection(context, tasksState),
                          AppSizes.gapV32,
                          _buildDeepWorkPlaceholder(context),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: AppSizes.gapV48),
            ],
          ),

          if (_currentCelebration != CelebrationType.none)
            Positioned.fill(
              child: CelebrationOverlay(
                type: _currentCelebration,
                onComplete: () {
                  if (mounted) setState(() => _currentCelebration = CelebrationType.none);
                },
              ),
            ),
        ],
      ),
    );
  }
}