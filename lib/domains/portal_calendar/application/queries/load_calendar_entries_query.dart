import '../../domain/value_objects/calendar_event_date_range.dart';

class LoadCalendarEntriesQuery {
  final DateTime focusedMonth;

  const LoadCalendarEntriesQuery({required this.focusedMonth});

  CalendarEventDateRange toRange() {
    return CalendarEventDateRange.month(focusedMonth);
  }
}
