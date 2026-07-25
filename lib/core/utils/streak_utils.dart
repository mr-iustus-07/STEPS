import 'date_utils.dart';

class StreakUtils {
  StreakUtils._();

  /// Calculates the new streak count based on the last completion date.
  /// Call this BEFORE saving a newly completed routine to the database.
  static int calculateNewStreak({
    required DateTime now,
    required DateTime? lastCompletedDate,
    required int currentStreak,
  }) {
    // First time completing the routine
    if (lastCompletedDate == null) return 1;

    final today = AppDateUtils.startOfDay(now);
    final lastCompletionDay = AppDateUtils.startOfDay(lastCompletedDate);
    final difference = today.difference(lastCompletionDay).inDays;

    if (difference == 0) {
      // Already completed today, streak remains the same
      return currentStreak;
    } else if (difference == 1) {
      // Completed yesterday, streak increments!
      return currentStreak + 1;
    } else {
      // Missed a day (or more). Streak resets.
      return 1;
    }
  }

  /// Determines if a streak is currently active or broken.
  /// Useful for UI rendering (e.g., graying out the fire icon).
  static bool isStreakActive(DateTime? lastCompletedDate) {
    if (lastCompletedDate == null) return false;
    
    final today = AppDateUtils.startOfDay(DateTime.now());
    final lastCompletionDay = AppDateUtils.startOfDay(lastCompletedDate);
    final difference = today.difference(lastCompletionDay).inDays;

    // Active if completed today or yesterday
    return difference <= 1;
  }

  /// Calculates the next major milestone for gamification.
  /// (e.g., 7 days, 30 days, 100 days)
  static int getNextMilestone(int currentStreak) {
    const milestones = [7, 14, 21, 30, 50, 100, 365, 1000];
    
    for (final milestone in milestones) {
      if (currentStreak < milestone) {
        return milestone;
      }
    }
    return currentStreak + 100; // Fallback for massive streaks
  }
}