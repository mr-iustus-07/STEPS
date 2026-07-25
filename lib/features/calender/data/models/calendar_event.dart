import 'package:isar/isar.dart';

part 'calendar_event.g.dart';

@collection
class CalendarEvent {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  @Index()
  late DateTime date;

  /// Precise timing for the timeline
  int? startTimeInMinutes;
  int? endTimeInMinutes;

  /// If true, this event repeats every year (Historical/Memories)
  bool isYearly = false; 

  String? description;
  DateTime createdAt = DateTime.now();
}