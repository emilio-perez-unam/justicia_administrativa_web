class CalendarEventType {
  static const Set<String> allowedValues = {
    'reunion',
    'audiencia',
    'entrega',
    'vencimiento',
    'otro',
  };

  final String value;

  CalendarEventType(String value) : value = _normalize(value);

  static String _normalize(String value) {
    final normalized = value.trim().toLowerCase();
    if (allowedValues.contains(normalized)) return normalized;
    return 'otro';
  }
}
