import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/presentation/future_result_view.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domains/portal_calendar/application/commands/create_calendar_event_command.dart';
import '../../../domains/portal_calendar/application/commands/update_calendar_task_status_command.dart';
import '../../../domains/portal_calendar/application/queries/load_calendar_entries_query.dart';
import '../../../domains/portal_calendar/application/use_cases/create_calendar_event_use_case.dart';
import '../../../domains/portal_calendar/application/use_cases/load_calendar_entries_use_case.dart';
import '../../../domains/portal_calendar/application/use_cases/load_calendar_matters_use_case.dart';
import '../../../domains/portal_calendar/application/use_cases/update_calendar_task_status_use_case.dart';
import '../../../domains/portal_calendar/actors/calendar_interaction_actor.dart';
import '../../../domains/portal_calendar/domain/entities/portal_calendar_event.dart';
import '../../../domains/portal_calendar/domain/entities/portal_calendar_matter.dart';
import '../../../domains/portal_calendar/domain/entities/portal_calendar_task.dart';

part 'calendar/calendar_view_widgets.dart';
part 'calendar/calendar_month_grid.dart';

class CalendarView extends StatefulWidget {
  /// Override for the calendar entries loader (testing only).
  ///
  /// Receives the focused [DateTime] and returns the entries for that month.
  @visibleForTesting
  final Future<PortalCalendarEntries> Function(DateTime)? entriesLoaderOverride;

  const CalendarView({super.key, this.entriesLoaderOverride});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // Lazily resolved from DI so test mode (entriesLoaderOverride != null) can
  // skip getIt calls and pump without a registered service locator.
  late final LoadCalendarEntriesUseCase _loadCalendarEntries =
      getIt<LoadCalendarEntriesUseCase>();
  late final LoadCalendarMattersUseCase _loadCalendarMatters =
      getIt<LoadCalendarMattersUseCase>();
  late final CreateCalendarEventUseCase _createCalendarEvent =
      getIt<CreateCalendarEventUseCase>();
  late final UpdateCalendarTaskStatusUseCase _updateCalendarTaskStatus =
      getIt<UpdateCalendarTaskStatusUseCase>();
  late final CalendarInteractionActor _interactionActor;
  late final StreamSubscription<CalendarInteractionState>
  _interactionSubscription;

  // Key is re-created on month change / manual reload to force FutureResultView
  // to re-invoke its loader for the new month.
  late Key _entriesKey;

  @override
  void initState() {
    super.initState();
    _interactionActor = CalendarInteractionActor();
    _focusedDay = _interactionActor.state.focusedMonth;
    _selectedDay = _interactionActor.state.selectedDay;
    _entriesKey = ValueKey(_focusedDay);
    _interactionSubscription = _interactionActor.stream.listen(
      _applyInteractionState,
    );
  }

  @override
  void dispose() {
    unawaited(_interactionSubscription.cancel());
    unawaited(_interactionActor.dispose());
    super.dispose();
  }

  void _loadData() {
    setState(() => _entriesKey = UniqueKey());
  }

  Future<PortalCalendarEntries> _fetchDataForMonth(DateTime focusedDay) {
    final override = widget.entriesLoaderOverride;
    if (override != null) return override(focusedDay);
    return _loadCalendarEntries(
      LoadCalendarEntriesQuery(focusedMonth: focusedDay),
    );
  }

  void _onMonthChanged(int offset) {
    _interactionActor.dispatch(CalendarMonthChanged(offset));
  }

  void _selectDay(DateTime day) {
    _interactionActor.dispatch(CalendarDaySelected(day));
  }

  void _applyInteractionState(CalendarInteractionState nextState) {
    if (!mounted) return;
    final shouldReload = nextState.focusedMonth != _focusedDay;
    setState(() {
      _focusedDay = nextState.focusedMonth;
      _selectedDay = nextState.selectedDay;
      if (shouldReload) {
        _entriesKey = ValueKey(_focusedDay);
      }
    });
  }

  Future<void> _showNewEventDialog() async {
    List<PortalCalendarMatter> matters = [];
    try {
      matters = await _loadCalendarMatters();
    } catch (error) {
      debugPrint(
        'CalendarView could not load matters for event dialog: $error',
      );
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => _NewEventDialog(
        matters: matters,
        initialDate: _selectedDay ?? DateTime.now(),
        onSave: _createEvent,
      ),
    );
  }

  Future<void> _createEvent(
    String title,
    String desc,
    DateTime date,
    String type,
    String? matterId,
  ) async {
    try {
      await _createCalendarEvent(
        CreateCalendarEventCommand(
          title: title,
          description: desc,
          eventDate: date,
          eventType: type,
          matterId: matterId,
        ),
      );
      if (mounted) {
        Navigator.pop(context);
        toastification.show(
          context: context,
          title: const Text('Evento creado con éxito'),
          type: ToastificationType.success,
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Error al crear evento'),
          description: Text(e.toString()),
          type: ToastificationType.error,
        );
      }
    }
  }

  Future<void> _toggleTaskStatus(
    PortalCalendarTask task,
    bool completed,
  ) async {
    try {
      await _updateCalendarTaskStatus(
        UpdateCalendarTaskStatusCommand(taskId: task.id, completed: completed),
      );
      _loadData();
    } catch (error) {
      if (!mounted) return;
      toastification.show(
        context: context,
        title: const Text('Error al actualizar tarea'),
        description: Text(error.toString()),
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Calendario",
                  style: TextStyle(
                    fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                    fontSize: isMobile ? 26 : 30,
                    fontWeight: FontWeight.bold,
                    color: navyColor,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _showNewEventDialog,
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: Text(isMobile ? "Nuevo" : "Nuevo Evento"),
                  style: FilledButton.styleFrom(
                    backgroundColor: navyColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Read #6 — calendar entries
            FutureResultView<PortalCalendarEntries>(
              key: _entriesKey,
              loader: () => _fetchDataForMonth(_focusedDay),
              builder: (context, entries) {
                if (entries.events.isEmpty && entries.tasks.isEmpty) {
                  return const Center(child: Text('No hay eventos ni tareas.'));
                }

                final eventsByDay = entries.eventsByDay(_focusedDay);
                final tasksByDay = entries.tasksByDay(_focusedDay);
                final selectedDayEvents = entries.eventsOn(_selectedDay);
                final selectedDayTasks = entries.tasksOn(_selectedDay);

                if (isMobile) {
                  return Column(
                    children: [
                      _buildCalendarCard(
                        eventsByDay,
                        tasksByDay,
                        colors,
                        navyColor,
                      ),
                      const SizedBox(height: 24),
                      _buildItemsListCard(
                        selectedDayEvents,
                        selectedDayTasks,
                        navyColor,
                        colors,
                        isMobile,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildCalendarCard(
                        eventsByDay,
                        tasksByDay,
                        colors,
                        navyColor,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _buildItemsListCard(
                        selectedDayEvents,
                        selectedDayTasks,
                        navyColor,
                        colors,
                        isMobile,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarCard(
    Map<int, List<PortalCalendarEvent>> eventsByDay,
    Map<int, List<PortalCalendarTask>> tasksByDay,
    dynamic colors,
    Color navyColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.chevronLeft, size: 20),
                onPressed: () => _onMonthChanged(-1),
              ),
              Text(
                DateFormat('MMMM yyyy', 'es').format(_focusedDay).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: navyColor,
                  letterSpacing: 1,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.chevronRight, size: 20),
                onPressed: () => _onMonthChanged(1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['DO', 'LU', 'MA', 'MI', 'JU', 'VI', 'SA']
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(
                      color: colors.mutedForeground,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Divider(color: colors.border),
          const SizedBox(height: 12),
          _CalendarMonthGrid(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            eventsByDay: eventsByDay,
            tasksByDay: tasksByDay,
            onDaySelected: _selectDay,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsListCard(
    List<PortalCalendarEvent> events,
    List<PortalCalendarTask> tasks,
    Color navyColor,
    dynamic colors,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(minHeight: isMobile ? 0 : 500),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedDay != null
                ? DateFormat('EEEE d, MMMM', 'es').format(_selectedDay!)
                : 'Seleccione un día',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          const SizedBox(height: 20),
          if (events.isEmpty && tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 40,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Sin actividad para este día",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            if (events.isNotEmpty) ...[
              const _SectionLabel(label: "EVENTOS", icon: LucideIcons.calendar),
              const SizedBox(height: 12),
              ...events.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _EventCard(event: e),
                ),
              ),
            ],
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _SectionLabel(
                label: "TAREAS",
                icon: LucideIcons.checkSquare,
              ),
              const SizedBox(height: 12),
              ...tasks.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TaskCalendarCard(
                    task: t,
                    onToggle: (completed) => _toggleTaskStatus(t, completed),
                  ),
                ),
              ),
            ],
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _loadData(),
            icon: const Icon(LucideIcons.refreshCw, size: 14),
            label: const Text("Actualizar"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: colors.mutedForeground,
              side: BorderSide(color: colors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
