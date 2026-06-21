import '../value_objects/calendar_event_type.dart';

class PortalCalendarEvent {
  final String id;
  final String clientId;
  final String? matterId;
  final String title;
  final String? description;
  final CalendarEventType eventType;
  final DateTime eventDate;
  final String? location;
  final String? matterTitle;

  const PortalCalendarEvent({
    required this.id,
    required this.clientId,
    required this.matterId,
    required this.title,
    required this.description,
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.matterTitle,
  });

  bool occursOn(DateTime day) {
    return eventDate.year == day.year &&
        eventDate.month == day.month &&
        eventDate.day == day.day;
  }
}

class PortalCalendarEventDraft {
  final String title;
  final String description;
  final DateTime eventDate;
  final CalendarEventType eventType;
  final String? matterId;

  PortalCalendarEventDraft({
    required String title,
    required String description,
    required this.eventDate,
    required this.eventType,
    required this.matterId,
  }) : title = title.trim(),
       description = description.trim() {
    if (this.title.isEmpty) {
      throw ArgumentError('Calendar event title is required.');
    }
  }
}
