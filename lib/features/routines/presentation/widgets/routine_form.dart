import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../data/models/routine_model.dart';
import 'repeat_selector.dart';
import 'reminder_selector.dart';

class RoutineForm extends StatefulWidget {
  final RoutineModel? initialData;
  final Function(String title, List<int> repeatDays, TimeOfDay? reminderTime) onSave;
  final bool isSaving;

  const RoutineForm({
    super.key,
    this.initialData,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<RoutineForm> createState() => _RoutineFormState();
}

class _RoutineFormState extends State<RoutineForm> {
  late TextEditingController _titleController;
  late List<int> _selectedDays;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?.title ?? '');
    _selectedDays = widget.initialData?.repeatDays ?? [1, 2, 3, 4, 5, 6, 7];
    
    // 🔥 FIXED: Convert Isar targetTimeInMinutes back to TimeOfDay for the UI
    if (widget.initialData?.targetTimeInMinutes != null) {
      final int minutes = widget.initialData!.targetTimeInMinutes!;
      _selectedTime = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return; // Prevent saving empty routines
    widget.onSave(title, _selectedDays, _selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Input
        TextField(
          controller: _titleController,
          autofocus: true,
          style: context.textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g. Morning Workout...',
            hintStyle: context.textTheme.headlineSmall?.copyWith(color: AppColors.textDisabled, fontWeight: FontWeight.normal),
            border: InputBorder.none,
          ),
          onSubmitted: (_) => _submit(),
        ),
        
        AppSizes.gapV24,
        
        // Repeat Selector Component
        RepeatSelector(
          initialDays: _selectedDays,
          onChanged: (days) => setState(() => _selectedDays = days),
        ),
        
        AppSizes.gapV24,
        
        // Reminder Selector Component
        ReminderSelector(
          initialTime: _selectedTime,
          onChanged: (time) => setState(() => _selectedTime = time),
        ),
        
        AppSizes.gapV32,
        
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: widget.isSaving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              elevation: 0,
            ),
            child: widget.isSaving
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: AppColors.background, strokeWidth: 2))
                : Text(
                    widget.initialData != null ? 'UPDATE PROTOCOL' : 'ESTABLISH PROTOCOL',
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AppColors.background),
                  ),
          ),
        ),
      ],
    );
  }
}