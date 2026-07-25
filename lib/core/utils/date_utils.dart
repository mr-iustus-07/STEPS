import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  /// Returns 12:00:00 AM of the given date. Crucial for Isar DB range queries.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns 11:59:59 PM of the given date. Crucial for Isar DB range queries.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Checks if two dates fall on the exact same calendar day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Formats date for the Command Center UI (e.g., "OCT 24, 2026")
  static String formatSystemDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date).toUpperCase();
  }

  /// Formats time (e.g., "14:30" or "02:30 PM")
  static String formatTime(DateTime date, {bool use24Hour = false}) {
    return DateFormat(use24Hour ? 'HH:mm' : 'hh:mm a').format(date);
  }

  /// Converts a DateTime into a relative string for task lists.
  /// E.g., "Today, 14:00", "Yesterday", "In 2 days", or "OCT 24"
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final today = startOfDay(now);
    final targetDate = startOfDay(date);
    
    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Today, ${formatTime(date)}';
    } else if (difference == 1) {
      return 'Tomorrow, ${formatTime(date)}';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1 && difference <= 7) {
      return 'In $difference days';
    } else if (difference < -1 && difference >= -7) {
      return '${difference.abs()} days ago';
    } else {
      return formatSystemDate(date);
    }
  }
}