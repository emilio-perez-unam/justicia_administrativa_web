class CalendarEventDateRange {
  final DateTime start;
  final DateTime end;

  CalendarEventDateRange({required this.start, required this.end}) {
    if (end.isBefore(start)) {
      throw ArgumentError('Calendar date range end must not be before start.');
    }
  }

  factory CalendarEventDateRange.month(DateTime focusedMonth) {
    return CalendarEventDateRange(
      start: DateTime(focusedMonth.year, focusedMonth.month, 1),
      end: DateTime(focusedMonth.year, focusedMonth.month + 1, 0),
    );
  }

  bool contains(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }
}
