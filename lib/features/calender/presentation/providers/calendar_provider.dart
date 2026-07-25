import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/calendar_event.dart';

final calendarEventsProvider = AsyncNotifierProvider<CalendarNotifier, List<CalendarEvent>>(() {
  return CalendarNotifier();
});

class CalendarNotifier extends AsyncNotifier<List<CalendarEvent>> {
  late Isar _isar;

  @override
  Future<List<CalendarEvent>> build() async {
    _isar = Isar.getInstance()!;
    return _fetchEvents();
  }

  Future<List<CalendarEvent>> _fetchEvents() async {
    return await _isar.calendarEvents.where().sortByDate().findAll();
  }

  Future<void> deleteEvent(int id) async {
    await _isar.writeTxn(() async {
      await _isar.calendarEvents.delete(id);
    });
    state = AsyncValue.data(await _fetchEvents());
  }
  // Update your addEvent method in calendar_provider.dart to look like this:
  Future<void> addEvent(
    String title, 
    DateTime date, 
    bool isYearly, {
    int? startTime, 
    int? endTime,
  }) async {
    final newEvent = CalendarEvent()
      ..title = title
      ..date = date
      ..isYearly = isYearly
      ..startTimeInMinutes = startTime  // Now matches the model
      ..endTimeInMinutes = endTime;     // Now matches the model

    await _isar.writeTxn(() async {
      await _isar.calendarEvents.put(newEvent);
    });
    state = AsyncValue.data(await _fetchEvents());
  }
}