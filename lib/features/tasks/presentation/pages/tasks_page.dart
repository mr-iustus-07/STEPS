import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/create_task_modal.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  void _openCreateModal(BuildContext context, {TaskModel? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskModal(existingTask: task), 
    );
  }

  Widget _buildPriorityPill(TaskPriority priority, bool isCompleted, BuildContext context) {
    if (isCompleted) return const SizedBox.shrink(); 

    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.urgent:
        bgColor = AppColors.error.withValues(alpha:0.15);
        textColor = AppColors.error;
        label = 'URGENT';
        break;
      case TaskPriority.high:
        bgColor = AppColors.textPrimary.withValues(alpha:0.1);
        textColor = AppColors.textPrimary;
        label = 'HIGH';
        break;
      case TaskPriority.medium:
        bgColor = AppColors.textSecondary.withValues(alpha:0.1);
        textColor = AppColors.textSecondary;
        label = 'MEDIUM';
        break;
      case TaskPriority.low:
        bgColor = Colors.transparent;
        textColor = AppColors.textDisabled;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20), 
        border: priority == TaskPriority.low ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: textColor, 
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(pendingTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TASKS',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.navSettings),
            onPressed: () => context.push('/settings'),
          ),
          AppSizes.gapH8,
        ],
      ),
      body: tasksState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
        data: (tasks) {
          if (tasks.isEmpty) {
            return EmptyState(
              icon: AppIcons.navTasks,
              title: 'NO PENDING TASKS',
              message: 'You are all caught up. Add a new task to get started.',
              actionLabel: 'ADD TASK',
              onActionTap: () => _openCreateModal(context),
            );
          }

          final pendingCount = tasks.where((t) => !t.isCompleted).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceHighlight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(AppIcons.navTasks, size: 16, color: AppColors.accent),
                    ),
                    AppSizes.gapH12,
                    Text(
                      'You have $pendingCount pending tasks',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.p12),
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSizes.p16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // 🔥 SNACKBAR COMPLETELY DELETED.
                                // It just updates the database and the UI instantly reacts.
                                ref.read(pendingTasksProvider.notifier).toggleTask(task.id);
                              },
                              child: Container(
                                height: 26,
                                width: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: task.isCompleted ? AppColors.textPrimary : Colors.transparent, 
                                  border: Border.all(
                                    color: task.isCompleted ? AppColors.textPrimary : AppColors.border, 
                                    width: 2,
                                  ),
                                ),
                                child: task.isCompleted 
                                  ? const Icon(Icons.check, size: 16, color: AppColors.background)
                                  : null,
                              ),
                            ),
                            AppSizes.gapH16,
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: task.isCompleted ? AppColors.textDisabled : AppColors.textPrimary,
                                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  
                                  if (task.dueDate != null || !task.isCompleted) ...[
                                    AppSizes.gapV8,
                                    Row(
                                      children: [
                                        if (task.dueDate != null) ...[
                                          Icon(
                                            Icons.calendar_today, 
                                            size: 12, 
                                            color: (task.isOverdue && !task.isCompleted) ? AppColors.error : AppColors.textDisabled
                                          ),
                                          AppSizes.gapH4,
                                          Text(
                                            task.dueDate!.toSystemFormat,
                                            style: context.textTheme.labelSmall?.copyWith(
                                              color: (task.isOverdue && !task.isCompleted) ? AppColors.error : AppColors.textDisabled,
                                              fontWeight: (task.isOverdue && !task.isCompleted) ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                          AppSizes.gapH12,
                                        ],
                                        _buildPriorityPill(task.priority, task.isCompleted, context),
                                      ],
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              color: AppColors.surfaceHighlight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _openCreateModal(context, task: task);
                                } else if (value == 'delete') {
                                  ref.read(pendingTasksProvider.notifier).deleteTask(task.id);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('EDIT', style: context.textTheme.labelLarge?.copyWith(color: AppColors.textPrimary)),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('DELETE', style: context.textTheme.labelLarge?.copyWith(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // 🔥 UPGRADED EXTENDED FAB: The Modern "Floating Bubble"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateModal(context),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.background,
        elevation: 4,
        icon: const Icon(AppIcons.add),
        label: Text(
          'NEW TASK',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.background,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}