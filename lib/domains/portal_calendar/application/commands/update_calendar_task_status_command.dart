import '../../domain/entities/portal_calendar_task.dart';

class UpdateCalendarTaskStatusCommand {
  final String taskId;
  final bool completed;

  const UpdateCalendarTaskStatusCommand({
    required this.taskId,
    required this.completed,
  });

  PortalCalendarTaskStatus get status => completed
      ? PortalCalendarTaskStatus.completed
      : PortalCalendarTaskStatus.pending;
}
