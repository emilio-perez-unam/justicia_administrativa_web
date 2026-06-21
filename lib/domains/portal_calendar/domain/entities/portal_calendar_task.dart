enum PortalCalendarTaskStatus {
  pending('pendiente'),
  inProgress('en_progreso'),
  completed('completada'),
  canceled('cancelada');

  final String dbValue;

  const PortalCalendarTaskStatus(this.dbValue);

  static PortalCalendarTaskStatus fromDb(String value) {
    return PortalCalendarTaskStatus.values.firstWhere(
      (status) => status.dbValue == value,
      orElse: () => PortalCalendarTaskStatus.pending,
    );
  }
}

class PortalCalendarTask {
  final String id;
  final String title;
  final String assigneeName;
  final DateTime? dueDate;
  final PortalCalendarTaskStatus status;

  const PortalCalendarTask({
    required this.id,
    required this.title,
    required this.assigneeName,
    required this.dueDate,
    required this.status,
  });

  bool get isCompleted => status == PortalCalendarTaskStatus.completed;

  bool isDueOn(DateTime day) {
    final due = dueDate;
    return due != null &&
        due.year == day.year &&
        due.month == day.month &&
        due.day == day.day;
  }
}
