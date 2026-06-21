import '../entities/portal_calendar_event.dart';
import '../entities/portal_calendar_matter.dart';
import '../entities/portal_calendar_task.dart';
import '../value_objects/calendar_event_date_range.dart';

abstract class PortalCalendarRepository {
  Future<List<PortalCalendarEvent>> getEvents(CalendarEventDateRange range);

  Future<List<PortalCalendarTask>> getTasks(CalendarEventDateRange range);

  Future<List<PortalCalendarMatter>> getMatters();

  Future<void> createEvent(PortalCalendarEventDraft draft);

  Future<void> updateTaskStatus({
    required String taskId,
    required PortalCalendarTaskStatus status,
  });
}
