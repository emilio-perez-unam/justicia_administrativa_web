import '../../domain/entities/portal_calendar_matter.dart';
import '../../domain/repositories/portal_calendar_repository.dart';

class LoadCalendarMattersUseCase {
  final PortalCalendarRepository _repository;

  const LoadCalendarMattersUseCase(this._repository);

  Future<List<PortalCalendarMatter>> call() {
    return _repository.getMatters();
  }
}
