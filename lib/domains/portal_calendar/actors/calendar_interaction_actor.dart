import 'dart:async';

abstract class CalendarInteractionMessage {
  const CalendarInteractionMessage();
}

class CalendarMonthChanged extends CalendarInteractionMessage {
  final int offset;

  const CalendarMonthChanged(this.offset);
}

class CalendarDaySelected extends CalendarInteractionMessage {
  final DateTime day;

  const CalendarDaySelected(this.day);
}

class CalendarInteractionState {
  final DateTime focusedMonth;
  final DateTime selectedDay;

  const CalendarInteractionState({
    required this.focusedMonth,
    required this.selectedDay,
  });

  factory CalendarInteractionState.initial(DateTime now) {
    final normalized = DateTime(now.year, now.month, now.day);
    return CalendarInteractionState(
      focusedMonth: DateTime(now.year, now.month, 1),
      selectedDay: normalized,
    );
  }

  CalendarInteractionState copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDay,
  }) {
    return CalendarInteractionState(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

class CalendarInteractionActor {
  final StreamController<CalendarInteractionState> _controller =
      StreamController<CalendarInteractionState>.broadcast();

  CalendarInteractionState _state;
  bool _isDisposed = false;

  CalendarInteractionActor({DateTime? now})
    : _state = CalendarInteractionState.initial(now ?? DateTime.now());

  CalendarInteractionState get state => _state;

  Stream<CalendarInteractionState> get stream => _controller.stream;

  void dispatch(CalendarInteractionMessage message) {
    if (_isDisposed) return;

    if (message is CalendarMonthChanged) {
      final focused = _state.focusedMonth;
      _emit(
        _state.copyWith(
          focusedMonth: DateTime(
            focused.year,
            focused.month + message.offset,
            1,
          ),
        ),
      );
      return;
    }

    if (message is CalendarDaySelected) {
      _emit(_state.copyWith(selectedDay: message.day));
    }
  }

  void _emit(CalendarInteractionState nextState) {
    _state = nextState;
    _controller.add(nextState);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await _controller.close();
  }
}
