import '../../domain/repositories/portal_calendar_repository.dart';
import '../commands/update_calendar_task_status_command.dart';

class UpdateCalendarTaskStatusUseCase {
  final PortalCalendarRepository _repository;

  const UpdateCalendarTaskStatusUseCase(this._repository);

  Future<void> call(UpdateCalendarTaskStatusCommand command) {
    return _repository.updateTaskStatus(
      taskId: command.taskId,
      status: command.status,
    );
  }
}
