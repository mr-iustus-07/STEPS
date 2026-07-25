import 'package:isar/isar.dart';

part 'event_model.g.dart';

@collection
class EventModel {
  Id id = Isar.autoIncrement;

  late String title;
  
  String? description;
  
  String? location; // e.g., "Main Conference Room" or a Zoom link

  // --- Time Boundaries ---
  /// Highly indexed for calendar range queries (e.g., "Get all events for this month")
  @Index()
  late DateTime startTime;
  
  late DateTime endTime;

  bool isAllDay = false;

  int? notificationId;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}