import '../../domain/repositories/portal_calendar_repository.dart';
import '../commands/create_calendar_event_command.dart';

class CreateCalendarEventUseCase {
  final PortalCalendarRepository _repository;

  const CreateCalendarEventUseCase(this._repository);

  Future<void> call(CreateCalendarEventCommand command) {
    return _repository.createEvent(command.toDraft());
  }
}
