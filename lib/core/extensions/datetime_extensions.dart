import '../utils/date_utils.dart';

extension DateTimeExtensions on DateTime {
  // --- Boolean Checks ---
  bool get isToday => AppDateUtils.isSameDay(this, DateTime.now());
  
  bool get isYesterday => 
      AppDateUtils.isSameDay(this, DateTime.now().subtract(const Duration(days: 1)));
      
  bool get isTomorrow => 
      AppDateUtils.isSameDay(this, DateTime.now().add(const Duration(days: 1)));

  bool isSameDayAs(DateTime other) => AppDateUtils.isSameDay(this, other);

  // --- Database Boundary Adjustments ---
  DateTime get startOfDay => AppDateUtils.startOfDay(this);
  DateTime get endOfDay => AppDateUtils.endOfDay(this);

  // --- Formatting (Bridging to UI) ---
  /// Returns format: "OCT 24, 2026"
  String get toSystemFormat => AppDateUtils.formatSystemDate(this);
  
  /// Returns format: "Today, 14:00" or "In 2 days"
  String get toRelative => AppDateUtils.getRelativeTime(this);
  
  /// Returns format: "14:30"
  String get toTime => AppDateUtils.formatTime(this);
}