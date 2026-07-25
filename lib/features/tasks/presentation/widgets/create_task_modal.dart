import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

class CreateTaskModal extends ConsumerStatefulWidget {
  // 🔥 Added to allow the modal to act as an Editor
  final TaskModel? existingTask; 
  
  const CreateTaskModal({super.key, this.existingTask});

  @override
  ConsumerState<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends ConsumerState<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 🔥 If we are editing, pre-fill the form with the existing data
    if (widget.existingTask != null) {
      final t = widget.existingTask!;
      _titleController.text = t.title;
      _descController.text = t.description ?? '';
      _dueDate = t.dueDate;
      _priority = t.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // 🔥 If existingTask is not null, update it. Otherwise, create a new one.
    final taskToSave = widget.existingTask ?? TaskModel();
    taskToSave
      ..title = _titleController.text.trim()
      ..description = _descController.text.trim().isEmpty ? null : _descController.text.trim()
      ..dueDate = _dueDate
      ..priority = _priority;

    await ref.read(pendingTasksProvider.notifier).addTask(taskToSave);
    
    if (mounted) {
      context.showSystemMessage(widget.existingTask == null ? 'Task saved' : 'Task updated');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSizes.p24,
        right: AppSizes.p24,
        top: AppSizes.p24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'EDIT TASK' : 'NEW TASK',
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              AppSizes.gapV24,
              
              TextFormField(
                controller: _titleController,
                validator: (val) => AppValidators.requiredField(val, 'Task Name'),
                style: context.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'TASK NAME',
                  labelStyle: context.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                ),
              ),
              AppSizes.gapV24,

              Text(
                'PRIORITY',
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0),
              ),
              AppSizes.gapV8,
              SegmentedButton<TaskPriority>(
                segments: const [
                  ButtonSegment(value: TaskPriority.low, label: Text('LOW')),
                  ButtonSegment(value: TaskPriority.medium, label: Text('MED')),
                  ButtonSegment(value: TaskPriority.high, label: Text('HIGH')),
                  ButtonSegment(value: TaskPriority.urgent, label: Text('URGENT')),
                ],
                selected: {_priority},
                onSelectionChanged: (Set<TaskPriority> newSelection) {
                  setState(() => _priority = newSelection.first);
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  selectedBackgroundColor: AppColors.accent,
                  selectedForegroundColor: AppColors.background,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
              AppSizes.gapV24,

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'DEADLINE',
                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0),
                ),
                subtitle: Text(
                  _dueDate?.toSystemFormat ?? 'No deadline specified',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: _dueDate != null ? AppColors.accent : AppColors.textDisabled,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today, color: AppColors.textSecondary),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.accent,
                          surface: AppColors.surface,
                          onPrimary: AppColors.background,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (date != null) setState(() => _dueDate = date);
                },
              ),
              
              AppSizes.gapV32,
              PrimaryButton(
                label: isEditing ? 'UPDATE TASK' : 'SAVE TASK',
                isLoading: _isLoading,
                onPressed: _saveTask,
              ),
              AppSizes.gapV16,
            ],
          ),
        ),
      ),
    );
  }
}