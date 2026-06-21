import '../../domain/entities/portal_calendar_event.dart';
import '../../domain/entities/portal_calendar_task.dart';
import '../../domain/repositories/portal_calendar_repository.dart';
import '../queries/load_calendar_entries_query.dart';

class PortalCalendarEntries {
  final List<PortalCalendarEvent> events;
  final List<PortalCalendarTask> tasks;

  const PortalCalendarEntries({required this.events, required this.tasks});

  static const empty = PortalCalendarEntries(
    events: <PortalCalendarEvent>[],
    tasks: <PortalCalendarTask>[],
  );

  Map<int, List<PortalCalendarEvent>> eventsByDay(DateTime focusedMonth) {
    final grouped = <int, List<PortalCalendarEvent>>{};
    for (final event in events) {
      if (event.eventDate.month == focusedMonth.month &&
          event.eventDate.year == focusedMonth.year) {
        grouped.putIfAbsent(event.eventDate.day, () => []).add(event);
      }
    }
    return grouped;
  }

  Map<int, List<PortalCalendarTask>> tasksByDay(DateTime focusedMonth) {
    final grouped = <int, List<PortalCalendarTask>>{};
    for (final task in tasks) {
      final dueDate = task.dueDate;
      if (dueDate != null &&
          dueDate.month == focusedMonth.month &&
          dueDate.year == focusedMonth.year) {
        grouped.putIfAbsent(dueDate.day, () => []).add(task);
      }
    }
    return grouped;
  }

  List<PortalCalendarEvent> eventsOn(DateTime? day) {
    if (day == null) return <PortalCalendarEvent>[];
    return events.where((event) => event.occursOn(day)).toList();
  }

  List<PortalCalendarTask> tasksOn(DateTime? day) {
    if (day == null) return <PortalCalendarTask>[];
    return tasks.where((task) => task.isDueOn(day)).toList();
  }
}

class LoadCalendarEntriesUseCase {
  final PortalCalendarRepository _repository;

  const LoadCalendarEntriesUseCase(this._repository);

  Future<PortalCalendarEntries> call(LoadCalendarEntriesQuery query) async {
    final range = query.toRange();
    final eventsFuture = _repository.getEvents(range);
    final tasksFuture = _repository.getTasks(range);
    return PortalCalendarEntries(
      events: await eventsFuture,
      tasks: await tasksFuture,
    );
  }
}
