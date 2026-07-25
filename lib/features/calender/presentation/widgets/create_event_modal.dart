import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/calendar_provider.dart';

class CreateEventModal extends ConsumerStatefulWidget {
  final DateTime initialDate;
  const CreateEventModal({super.key, required this.initialDate});

  @override
  ConsumerState<CreateEventModal> createState() => _CreateEventModalState();
}

class _CreateEventModalState extends ConsumerState<CreateEventModal> {
  final _titleController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isYearly = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.p24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const Text('NEW EVENT', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty) {
                      ref.read(calendarEventsProvider.notifier).addEvent(
                        _titleController.text.trim(), _selectedDate, _isYearly,
                        startTime: (_startTime.hour * 60) + _startTime.minute,
                        endTime: (_endTime.hour * 60) + _endTime.minute,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TextField(controller: _titleController, autofocus: true, decoration: const InputDecoration(hintText: 'Add title')),
            ListTile(
              title: Text(DateFormat('EEE, MMM d').format(_selectedDate)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: () => _pickTime(true), child: Text(_startTime.format(context))),
                  TextButton(onPressed: () => _pickTime(false), child: Text(_endTime.format(context))),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Repeats Yearly'),
              value: _isYearly,
              onChanged: (val) => setState(() => _isYearly = val),
              activeThumbColor: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}