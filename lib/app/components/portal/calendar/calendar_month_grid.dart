part of '../calendar_view.dart';

class _CalendarMonthGrid extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<int, List<PortalCalendarEvent>> eventsByDay;
  final Map<int, List<PortalCalendarTask>> tasksByDay;
  final ValueChanged<DateTime> onDaySelected;

  const _CalendarMonthGrid({
    required this.focusedDay,
    required this.selectedDay,
    required this.eventsByDay,
    required this.tasksByDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final firstWeekday =
        DateTime(focusedDay.year, focusedDay.month, 1).weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final day = index - firstWeekday + 1;
        if (day < 1 || day > daysInMonth) return const SizedBox();

        return _CalendarDayCell(
          date: DateTime(focusedDay.year, focusedDay.month, day),
          isSelected: _isSelected(day),
          hasEvents: eventsByDay.containsKey(day),
          hasTasks: tasksByDay.containsKey(day),
          onSelected: onDaySelected,
        );
      },
    );
  }

  bool _isSelected(int day) {
    return selectedDay != null &&
        selectedDay!.day == day &&
        selectedDay!.month == focusedDay.month &&
        selectedDay!.year == focusedDay.year;
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasEvents;
  final bool hasTasks;
  final ValueChanged<DateTime> onSelected;

  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.hasEvents,
    required this.hasTasks,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(date);

    return GestureDetector(
      onTap: () => onSelected(date),
      child: AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E3A8A)
              : (isToday ? Colors.amber.shade50 : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor(isToday)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isToday ? Colors.amber.shade900 : Colors.black87),
                fontWeight: isSelected || isToday || hasEvents || hasTasks
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if ((hasEvents || hasTasks) && !isSelected)
              _CalendarDayActivityDots(
                hasEvents: hasEvents,
                hasTasks: hasTasks,
              ),
          ],
        ),
      ),
    );
  }

  Color _borderColor(bool isToday) {
    if (isSelected) return const Color(0xFF1E3A8A);
    if (isToday) return Colors.amber.shade200;
    if (hasEvents || hasTasks) return Colors.blue.shade50;
    return Colors.transparent;
  }

  bool _isToday(DateTime value) {
    final now = DateTime.now();
    return value.day == now.day &&
        value.month == now.month &&
        value.year == now.year;
  }
}

class _CalendarDayActivityDots extends StatelessWidget {
  final bool hasEvents;
  final bool hasTasks;

  const _CalendarDayActivityDots({
    required this.hasEvents,
    required this.hasTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasEvents) const _CalendarActivityDot(color: Colors.blue),
        if (hasEvents && hasTasks) const SizedBox(width: 2),
        if (hasTasks) const _CalendarActivityDot(color: Color(0xFFD4AF37)),
      ],
    );
  }
}

class _CalendarActivityDot extends StatelessWidget {
  final Color color;

  const _CalendarActivityDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
