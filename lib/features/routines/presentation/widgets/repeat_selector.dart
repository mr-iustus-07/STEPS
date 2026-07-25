import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';

class RepeatSelector extends StatefulWidget {
  final List<int> initialDays; // 1 = Monday, 7 = Sunday
  final Function(List<int>) onChanged;

  const RepeatSelector({
    super.key,
    this.initialDays = const [1, 2, 3, 4, 5, 6, 7], // Default to every day
    required this.onChanged,
  });

  @override
  State<RepeatSelector> createState() => _RepeatSelectorState();
}

class _RepeatSelectorState extends State<RepeatSelector> {
  late List<int> _selectedDays;
  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.initialDays);
  }

  void _toggleDay(int dayNum) {
    setState(() {
      if (_selectedDays.contains(dayNum)) {
        // Prevent deselecting the last day (a routine must happen on at least one day)
        if (_selectedDays.length > 1) {
          _selectedDays.remove(dayNum);
        }
      } else {
        _selectedDays.add(dayNum);
      }
      _selectedDays.sort();
      widget.onChanged(_selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REPEAT DAYS',
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        AppSizes.gapV12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final dayNum = index + 1; // 1-7
            final isSelected = _selectedDays.contains(dayNum);

            return GestureDetector(
              onTap: () => _toggleDay(dayNum),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.textPrimary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.textPrimary : AppColors.border,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _dayLabels[index],
                    style: context.textTheme.labelLarge?.copyWith(
                      color: isSelected ? AppColors.background : AppColors.textDisabled,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}