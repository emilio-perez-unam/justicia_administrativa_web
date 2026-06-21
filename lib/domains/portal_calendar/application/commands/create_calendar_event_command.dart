import '../../domain/entities/portal_calendar_event.dart';
import '../../domain/value_objects/calendar_event_type.dart';

class CreateCalendarEventCommand {
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventType;
  final String? matterId;

  const CreateCalendarEventCommand({
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventType,
    required this.matterId,
  });

  PortalCalendarEventDraft toDraft() {
    return PortalCalendarEventDraft(
      title: title,
      description: description,
      eventDate: eventDate,
      eventType: CalendarEventType(eventType),
      matterId: matterId,
    );
  }
}
