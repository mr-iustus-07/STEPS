import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Core Imports
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/extensions/context_extensions.dart';

// Feature Imports
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../routines/presentation/providers/routine_provider.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../routines/data/models/routine_model.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  // --- TABLE CALENDAR STATE ---
  CalendarFormat _calendarFormat = CalendarFormat.week; // Default to Week view to save space
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // --- UI CONTROLS ---

  Widget _buildTimelineEvent(String title, bool isCompleted, Color color, IconData icon, String exactTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.p8),
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.surfaceHighlight.withOpacity(0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: isCompleted ? AppColors.border.withOpacity(0.5) : color.withOpacity(0.5)),
        boxShadow: isCompleted ? [] : [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 8, spreadRadius: 1)
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isCompleted ? AppColors.textDisabled : color),
          AppSizes.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? AppColors.textDisabled : AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                AppSizes.gapV4,
                Text(
                  exactTime,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isCompleted ? AppColors.textDisabled : color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted) const Icon(Icons.check_circle, size: 16, color: AppColors.textDisabled),
        ],
      ),
    );
  }

  // --- THE CORE TIMELINE ENGINE ---

  bool _isRoutineCompletedOnDate(RoutineModel routine, DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return routine.isCompletedToday;
    }
    if (routine.lastCompletedDate != null) {
      return routine.lastCompletedDate!.year == date.year &&
             routine.lastCompletedDate!.month == date.month &&
             routine.lastCompletedDate!.day == date.day;
    }
    return false;
  }

  Widget _buildTimeline(List<RoutineModel> allRoutines, List<TaskModel> allTasks) {
    final activeDay = _selectedDay ?? _focusedDay;

    final activeRoutines = allRoutines.where((r) => r.repeatDays.contains(activeDay.weekday)).toList();
    
    final activeTasks = allTasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == activeDay.year && 
             t.dueDate!.month == activeDay.month && 
             t.dueDate!.day == activeDay.day;
    }).toList();

    final Map<int, List<({int minute, Widget widget})>> hourMap = {};

    // Group Routines
    for (var routine in activeRoutines) {
      final int totalMinutes = routine.targetTimeInMinutes ?? 0; 
      final int hour = totalMinutes ~/ 60;
      final int minute = totalMinutes % 60;
      
      final bool isDone = _isRoutineCompletedOnDate(routine, activeDay);
      final String timeStr = DateFormat('hh:mm a').format(DateTime(2000, 1, 1, hour, minute));

      hourMap.putIfAbsent(hour, () => []);
      hourMap[hour]!.add((
        minute: minute,
        widget: _buildTimelineEvent(routine.title.toUpperCase(), isDone, AppColors.accent, AppIcons.streakFire, timeStr)
      ));
    }

    // Group Tasks
    for (var task in activeTasks) {
      final int hour = task.dueDate!.hour;
      final int minute = task.dueDate!.minute;
      final String timeStr = DateFormat('hh:mm a').format(task.dueDate!);

      hourMap.putIfAbsent(hour, () => []);
      hourMap[hour]!.add((
        minute: minute,
        widget: _buildTimelineEvent(task.title, task.isCompleted, AppColors.textPrimary, Icons.task_alt, timeStr)
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 24, // Full 24-hour cycle
        itemBuilder: (context, index) {
          final hour = index;
          final eventsList = hourMap[hour] ?? [];
          
          final bool hasEvents = eventsList.isNotEmpty;

          List<Widget> sortedWidgets = [];
          if (hasEvents) {
            eventsList.sort((a, b) => a.minute.compareTo(b.minute));
            sortedWidgets = eventsList.map((e) => e.widget).toList();
          }
          
          final String ampm = hour >= 12 ? 'PM' : 'AM';
          final int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          final String timeLabel = '${displayHour.toString().padLeft(2, '0')}:00 $ampm';

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppSizes.gapV16,
                      Text(
                        timeLabel,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: hasEvents ? AppColors.textPrimary : AppColors.textDisabled,
                          fontWeight: hasEvents ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSizes.gapH16,
                Column(
                  children: [
                    Container(height: 16, width: 2, color: hasEvents ? AppColors.textPrimary : AppColors.border),
                    Container(
                      height: 8, width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: hasEvents ? AppColors.textPrimary : AppColors.border, width: 2),
                      ),
                    ),
                    Expanded(child: Container(width: 2, color: hasEvents ? AppColors.textPrimary : AppColors.border)),
                  ],
                ),
                AppSizes.gapH24,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
                    child: hasEvents
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: sortedWidgets)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSizes.gapV8,
                            Container(height: 2, width: 40, color: AppColors.border.withOpacity(0.5))
                          ],
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routinesState = ref.watch(activeRoutinesProvider);
    final tasksState = ref.watch(pendingTasksProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
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
                  Text('SCHEDULE', style: context.textTheme.labelSmall?.copyWith(color: AppColors.accent, letterSpacing: 2.0, fontWeight: FontWeight.bold)),
                  AppSizes.gapV4,
                  Text('CALENDAR', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),

          // 🔥 THE NEW GOOGLE CALENDAR GRID
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2050, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  
                  // Styling to match your premium minimal design
                  headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                      border: Border.all(color: AppColors.border), 
                      borderRadius: BorderRadius.circular(12)
                    ),
                    formatButtonTextStyle: context.textTheme.labelSmall!.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    titleTextStyle: context.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
                    rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: context.textTheme.labelSmall!.copyWith(color: AppColors.textDisabled, fontWeight: FontWeight.bold),
                    weekendStyle: context.textTheme.labelSmall!.copyWith(color: AppColors.textDisabled, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.textPrimary),
                    weekendTextStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
                    todayDecoration: BoxDecoration(
                      color: AppColors.surfaceHighlight, 
                      shape: BoxShape.circle, 
                      border: Border.all(color: AppColors.border)
                    ),
                    todayTextStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.textPrimary, 
                      shape: BoxShape.circle
                    ),
                    selectedTextStyle: context.textTheme.bodyMedium!.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                  ),
                  
                  // Interaction Logic
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() => _calendarFormat = format);
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: AppSizes.gapV32),

          // THE TIMELINE
          SliverToBoxAdapter(
            child: routinesState.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
              data: (routines) {
                return tasksState.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                  error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
                  data: (tasks) {
                    return _buildTimeline(routines, tasks);
                  },
                );
              },
            ),
          ),
          
          const SliverToBoxAdapter(child: AppSizes.gapV48),
        ],
      ),
    );
  }
}