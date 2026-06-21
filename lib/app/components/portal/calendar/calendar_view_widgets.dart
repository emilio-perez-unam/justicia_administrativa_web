part of '../calendar_view.dart';

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: context.colors.mutedForeground),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: context.colors.mutedForeground,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final PortalCalendarEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(event.eventType.value);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('HH:mm').format(event.eventDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.eventType.value.toUpperCase(),
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'audiencia':
        return Colors.red.shade700;
      case 'entrega':
        return Colors.purple.shade700;
      case 'reunion':
        return Colors.blue.shade700;
      case 'vencimiento':
        return Colors.orange.shade700;
      default:
        return Colors.teal.shade700;
    }
  }
}

class _TaskCalendarCard extends StatelessWidget {
  final PortalCalendarTask task;
  final ValueChanged<bool> onToggle;
  const _TaskCalendarCard({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color(0xFFD4AF37);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: goldColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goldColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            activeColor: Colors.green,
            onChanged: (val) {
              if (val != null) onToggle(val);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  task.assigneeName,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewEventDialog extends StatefulWidget {
  final List<PortalCalendarMatter> matters;
  final DateTime initialDate;
  final Future<void> Function(String, String, DateTime, String, String?) onSave;
  const _NewEventDialog({
    required this.matters,
    required this.initialDate,
    required this.onSave,
  });
  @override
  State<_NewEventDialog> createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<_NewEventDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _eventType = 'reunion';
  String? _selectedMatterId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _titleController.addListener(_refreshSaveState);
  }

  @override
  void dispose() {
    _titleController
      ..removeListener(_refreshSaveState)
      ..dispose();
    _descController.dispose();
    super.dispose();
  }

  void _refreshSaveState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Programar Evento'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título del evento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Notas adicionales',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 30),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (!context.mounted || d == null) {
                          return;
                        }
                        setState(() => _selectedDate = d);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final t = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (!context.mounted || t == null) {
                          return;
                        }
                        setState(() => _selectedTime = t);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Hora',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _eventType,
                items: const [
                  DropdownMenuItem(value: 'reunion', child: Text('Reunión')),
                  DropdownMenuItem(
                    value: 'audiencia',
                    child: Text('Audiencia'),
                  ),
                  DropdownMenuItem(value: 'entrega', child: Text('Entrega')),
                  DropdownMenuItem(
                    value: 'vencimiento',
                    child: Text('Vencimiento'),
                  ),
                  DropdownMenuItem(value: 'otro', child: Text('Otro')),
                ],
                onChanged: (val) {
                  if (val == null) {
                    return;
                  }
                  setState(() => _eventType = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de Evento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMatterId,
                items: widget.matters
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.title, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedMatterId = val),
                decoration: const InputDecoration(
                  labelText: 'Asunto Relacionado (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: (_titleController.text.isEmpty || _isLoading)
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  final dt = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  await widget.onSave(
                    _titleController.text,
                    _descController.text,
                    dt,
                    _eventType,
                    _selectedMatterId,
                  );
                },
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Guardar Evento'),
        ),
      ],
    );
  }
}
