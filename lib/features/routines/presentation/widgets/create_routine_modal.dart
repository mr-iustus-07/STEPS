import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../data/models/routine_model.dart';
import '../providers/routine_provider.dart';
import 'routine_form.dart'; 

class CreateRoutineModal extends ConsumerStatefulWidget {
  final RoutineModel? existingRoutine;

  const CreateRoutineModal({super.key, this.existingRoutine});

  @override
  ConsumerState<CreateRoutineModal> createState() => _CreateRoutineModalState();
}

class _CreateRoutineModalState extends ConsumerState<CreateRoutineModal> {
  bool _isSaving = false;

  Future<void> _handleSave(String title, List<int> repeatDays, TimeOfDay? reminderTime) async {
    setState(() => _isSaving = true);

    try {
      // 🔥 Convert TimeOfDay to minutes from midnight for your advanced DB model
      final int? minutesFromMidnight = reminderTime != null 
          ? (reminderTime.hour * 60) + reminderTime.minute 
          : null;

      if (widget.existingRoutine != null) {
        // --- EDIT MODE ---
        // await ref.read(activeRoutinesProvider.notifier).updateRoutine(...);
      } else {
        // --- CREATE MODE ---
        final newRoutine = RoutineModel()
          ..title = title
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now()
          ..currentStreak = 0
          ..longestStreak = 0
          ..isActive = true
          ..repeatDays = repeatDays
          ..targetTimeInMinutes = minutesFromMidnight; // Save as int!
          
        await ref.read(activeRoutinesProvider.notifier).addRoutine(newRoutine);
      }
      
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we are editing, we must convert the Int back to TimeOfDay for the UI Form
    RoutineModel? formReadyRoutine = widget.existingRoutine;
    
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.p24),
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(
              widget.existingRoutine != null ? 'EDIT PROTOCOL' : 'NEW PROTOCOL',
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.textSecondary),
            ),
            AppSizes.gapV16,
            
            RoutineForm(
              initialData: formReadyRoutine,
              isSaving: _isSaving,
              onSave: _handleSave,
            ),
            
            AppSizes.gapV16,
          ],
        ),
      ),
    );
  }
}