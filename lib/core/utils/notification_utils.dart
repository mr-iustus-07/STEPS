class NotificationUtils {
  NotificationUtils._();

  /// Converts a String (like a UUID) or a massive 64-bit database ID 
  /// into a safe 32-bit integer required by iOS/Android notification systems.
  /// This guarantees you can consistently target and cancel specific alarms.
  static int generateSafeId(String uniqueIdentifier) {
    // Uses the string's hashcode, which is inherently a 32-bit integer in Dart.
    // We use .abs() because notification IDs must be positive integers.
    return uniqueIdentifier.hashCode.abs();
  }

  /// Creates a standardized payload string.
  /// Example output: "/tasks|84729"
  /// When tapped, the app parses this and uses GoRouter to navigate directly to the item.
  static String createPayload({
    required String route,
    required String itemId,
  }) {
    return '$route|$itemId';
  }

  /// Parses the payload back into actionable routing data when the app wakes up.
  static Map<String, String>? parsePayload(String? payload) {
    if (payload == null || !payload.contains('|')) return null;
    
    final parts = payload.split('|');
    if (parts.length != 2) return null;

    return {
      'route': parts[0],
      'id': parts[1],
    };
  }

  /// Calculates the exact execution time for advance reminders.
  /// E.g., Event is at 14:00, user wants a 15-minute warning -> returns 13:45.
  static DateTime calculateAdvanceReminder(DateTime targetTime, int minutesBefore) {
    return targetTime.subtract(Duration(minutes: minutesBefore));
  }

  /// Generates a standard mission control briefing title for daily summaries.
  static String getMorningBriefingTitle() {
    final weekday = DateTime.now().weekday;
    switch (weekday) {
      case DateTime.monday:
        return 'System Online: Week Initialization';
      case DateTime.friday:
        return 'System Online: Final Push';
      case DateTime.saturday:
      case DateTime.sunday:
        return 'System Online: Maintenance & Planning';
      default:
        return 'System Online: Daily Directives';
    }
  }
}