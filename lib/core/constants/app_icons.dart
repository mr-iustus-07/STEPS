import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._(); // Prevent instantiation

  // ---------------------------------------------------------------------------
  // Navigation (Bottom Bar & App Bar)
  // ---------------------------------------------------------------------------
  static const IconData navDashboard = Icons.dashboard_outlined;
  static const IconData navRoutines = Icons.repeat_rounded;
  static const IconData navTasks = Icons.check_circle_outline_rounded;
  static const IconData navCalendar = Icons.calendar_today_rounded;
  static const IconData navSettings = Icons.settings_outlined;

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData forward = Icons.arrow_forward_ios_rounded;
  static const IconData check = Icons.check_rounded;

  // ---------------------------------------------------------------------------
  // Features & States (Dashboard / Streaks / Tasks)
  // ---------------------------------------------------------------------------
  static const IconData streakFire = Icons.local_fire_department_rounded;
  static const IconData milestone = Icons.emoji_events_outlined;
  
  static const IconData priorityHigh = Icons.keyboard_double_arrow_up_rounded;
  static const IconData priorityMedium = Icons.drag_handle_rounded;
  static const IconData priorityLow = Icons.keyboard_double_arrow_down_rounded;

  static const IconData time = Icons.access_time_rounded;
  static const IconData notificationActive = Icons.notifications_active_outlined;
  static const IconData notificationOff = Icons.notifications_off_outlined;

  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData unlock = Icons.lock_open_rounded;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  /// Returns a pre-configured Icon widget for standard actions to maintain 
  /// strict sizing and color compliance across the app.
  static Widget getIcon(IconData icon, {Color? color, double size = 24.0}) {
    return Icon(
      icon,
      color: color ?? const Color(0xFFFFFFFF), // Default to primary text/accent
      size: size,
    );
  }
}