class CalendarEvent {
  final String id;
  final String clientId;
  final String? matterId;
  final String title;
  final String? description;
  final String eventType;
  final DateTime eventDate;
  final String? location;
  final String? matterTitle;

  const CalendarEvent({
    required this.id,
    required this.clientId,
    this.matterId,
    required this.title,
    this.description,
    required this.eventType,
    required this.eventDate,
    this.location,
    this.matterTitle,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    final matter = json['matters'] as Map<String, dynamic>?;
    return CalendarEvent(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      matterId: json['matter_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventType: json['event_type'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      location: json['location'] as String?,
      matterTitle: matter?['title'] as String?,
    );
  }
}
