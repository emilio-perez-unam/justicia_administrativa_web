import '../../../core/models/calendar_event.dart' as core;
import '../../../core/models/matter.dart' as core;
import '../../../core/models/task.dart' as core;
import '../../../core/services/portal_service.dart';
import '../domain/entities/portal_calendar_event.dart';
import '../domain/entities/portal_calendar_matter.dart';
import '../domain/entities/portal_calendar_task.dart';
import '../domain/repositories/portal_calendar_repository.dart';
import '../domain/value_objects/calendar_event_date_range.dart';
import '../domain/value_objects/calendar_event_type.dart';

class PortalServiceCalendarRepository implements PortalCalendarRepository {
  const PortalServiceCalendarRepository();

  @override
  Future<List<PortalCalendarEvent>> getEvents(
    CalendarEventDateRange range,
  ) async {
    final events = await PortalService.getEvents(
      start: range.start,
      end: range.end,
    );
    return events.map(_mapEvent).toList(growable: false);
  }

  @override
  Future<List<PortalCalendarTask>> getTasks(
    CalendarEventDateRange range,
  ) async {
    final tasks = await PortalService.getTasksForCalendar(
      start: range.start,
      end: range.end,
    );
    return tasks.map(_mapTask).toList(growable: false);
  }

  @override
  Future<List<PortalCalendarMatter>> getMatters() async {
    final matters = await PortalService.getMatters();
    return matters.map(_mapMatter).toList(growable: false);
  }

  @override
  Future<void> createEvent(PortalCalendarEventDraft draft) {
    return PortalService.createEvent(
      title: draft.title,
      description: draft.description,
      date: draft.eventDate,
      eventType: draft.eventType.value,
      matterId: draft.matterId,
    );
  }

  @override
  Future<void> updateTaskStatus({
    required String taskId,
    required PortalCalendarTaskStatus status,
  }) {
    return PortalService.updateTaskStatus(taskId, status.dbValue);
  }

  PortalCalendarEvent _mapEvent(core.CalendarEvent event) {
    return PortalCalendarEvent(
      id: event.id,
      clientId: event.clientId,
      matterId: event.matterId,
      title: event.title,
      description: event.description,
      eventType: CalendarEventType(event.eventType),
      eventDate: event.eventDate,
      location: event.location,
      matterTitle: event.matterTitle,
    );
  }

  PortalCalendarTask _mapTask(core.Task task) {
    return PortalCalendarTask(
      id: task.id,
      title: task.title,
      assigneeName: task.assigneeName,
      dueDate: task.dueDate,
      status: PortalCalendarTaskStatus.fromDb(task.status.dbValue),
    );
  }

  PortalCalendarMatter _mapMatter(core.Matter matter) {
    return PortalCalendarMatter(id: matter.id, title: matter.title);
  }
}
