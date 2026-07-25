import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';

class ReminderSelector extends StatefulWidget {
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?) onChanged;

  const ReminderSelector({
    super.key,
    this.initialTime,
    required this.onChanged,
  });

  @override
  State<ReminderSelector> createState() => _ReminderSelectorState();
}

class _ReminderSelectorState extends State<ReminderSelector> {
  TimeOfDay? _selectedTime;
  bool _hasReminder = false;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _hasReminder = widget.initialTime != null;
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) {
        // Wraps the picker in dark theme if your app is dark
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _hasReminder = true;
      });
      widget.onChanged(_selectedTime);
    } else if (!_hasReminder) {
      // If they cancel and didn't already have a reminder, turn the switch back off
      setState(() => _hasReminder = false);
    }
  }

  void _toggleReminder(bool value) {
    if (value) {
      _selectTime();
    } else {
      setState(() {
        _hasReminder = false;
        _selectedTime = null;
      });
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _hasReminder ? AppColors.accent.withOpacity(0.1) : AppColors.surfaceHighlight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  size: 20,
                  color: _hasReminder ? AppColors.accent : AppColors.textDisabled,
                ),
              ),
              AppSizes.gapH16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Reminder',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_hasReminder && _selectedTime != null)
                    Text(
                      _selectedTime!.format(context),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Switch(
            value: _hasReminder,
            onChanged: _toggleReminder,
            activeThumbColor: AppColors.accent,
            inactiveTrackColor: AppColors.surfaceHighlight,
          ),
        ],
      ),
    );
  }
}