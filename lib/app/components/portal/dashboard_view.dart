import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/models/calendar_event.dart';
import '../../../core/models/matter.dart';
import '../../../core/models/portal_message.dart';
import '../../../core/models/portal_stats.dart';
import '../../../core/models/task.dart';
import '../../../core/presentation/future_result_view.dart';
import '../../../core/presentation/states/app_empty_state.dart';
import '../../../core/services/portal_service.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/context_extension.dart';
import '../shared/shimmer_loading.dart';
import 'dashboard/dashboard_message_row.dart';
import 'dashboard/dashboard_event_row.dart';

class DashboardView extends StatefulWidget {
  final Function(String) onNavigate;

  /// Override for the portal-stats loader (testing only).
  @visibleForTesting
  final Future<PortalStats> Function()? statsLoaderOverride;

  /// Override for the recent-matters loader (testing only).
  @visibleForTesting
  final Future<List<Matter>> Function()? mattersLoaderOverride;

  /// Override for the messages loader (testing only — future slice owns UI).
  @visibleForTesting
  final Future<List<PortalMessage>> Function()? messagesLoaderOverride;

  /// Override for the events loader (testing only — future slice owns UI).
  @visibleForTesting
  final Future<List<CalendarEvent>> Function()? eventsLoaderOverride;

  /// Override for the tasks loader (testing only — future slice owns UI).
  @visibleForTesting
  final Future<List<Task>> Function()? tasksLoaderOverride;

  const DashboardView({
    super.key,
    required this.onNavigate,
    this.statsLoaderOverride,
    this.mattersLoaderOverride,
    this.messagesLoaderOverride,
    this.eventsLoaderOverride,
    this.tasksLoaderOverride,
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late Future<List<PortalMessage>> Function() _messagesLoader;
  late Future<List<CalendarEvent>> Function() _eventsLoader;
  Future<List<Task>> Function()? _tasksDueLoader;

  @override
  void initState() {
    super.initState();
    _messagesLoader =
        widget.messagesLoaderOverride ?? PortalService.getRecentMessages;
    _eventsLoader =
        widget.eventsLoaderOverride ?? PortalService.getUpcomingEvents;
    _tasksDueLoader =
        widget.tasksLoaderOverride ?? PortalService.getTasksDueSoon;
  }

  @override
  Widget build(BuildContext context) {
    final navyColor = const Color(0xFF1E3A8A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, navyColor),
        const SizedBox(height: 32),

        // Read #1 — portal stats
        FutureResultView<PortalStats>(
          loader: widget.statsLoaderOverride ?? PortalService.getStats,
          builder: (ctx, stats) => _StatsGrid(stats: stats),
          loadingBuilder: (ctx) => _buildStatsLoading(ctx),
        ),

        const SizedBox(height: 32),

        // Read #2 — recent matters
        FutureResultView<List<Matter>>(
          loader: widget.mattersLoaderOverride ?? PortalService.getMatters,
          builder: (ctx, matters) {
            if (matters.isEmpty) {
              return _buildMattersEmpty();
            }
            return _ActiveMattersTable(
              matters: matters,
              onViewAll: () => widget.onNavigate('Mis Asuntos'),
            );
          },
          loadingBuilder: (ctx) =>
              const ShimmerSkeleton(width: double.infinity, height: 300),
        ),

        const SizedBox(height: 32),

        _buildLowerGrid(context),
      ],
    );
  }

  Widget _buildStatsLoading(BuildContext context) {
    final count = context.responsive(1, sm: 2, lg: 4);
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: List.generate(count, (index) => const StatCardSkeleton()),
    );
  }

  Widget _buildHeader(BuildContext context, Color navyColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido de nuevo',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: navyColor,
                fontFamily: 'serif',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Resumen de tu actividad jurídica al día de hoy",
              style: TextStyle(color: context.colors.mutedForeground),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMattersEmpty() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(child: Text('No hay asuntos recientes.')),
    );
  }

  Widget _buildLowerGrid(BuildContext context) {
    if (context.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _MessagesList(
              messagesLoader: _messagesLoader,
              onViewAll: () => widget.onNavigate('Mensajes'),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 1,
            child: _CalendarWidget(
              eventsLoader: _eventsLoader,
              tasksDueLoader: _tasksDueLoader,
              onViewAll: () => widget.onNavigate('Calendario'),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        _MessagesList(
          messagesLoader: _messagesLoader,
          onViewAll: () => widget.onNavigate('Mensajes'),
        ),
        const SizedBox(height: 32),
        _CalendarWidget(
          eventsLoader: _eventsLoader,
          tasksDueLoader: _tasksDueLoader,
          onViewAll: () => widget.onNavigate('Calendario'),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final PortalStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = context.responsive(1, sm: 2, lg: 4);
        final width = (constraints.maxWidth - (count - 1) * 20) / count;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _StatCard(
              label: "Asuntos Activos",
              value: "${stats.activeMatters}",
              icon: LucideIcons.folderOpen,
              color: Colors.blue,
            ),
            _StatCard(
              label: "Documentos",
              value: "${stats.totalDocuments}",
              icon: LucideIcons.fileText,
              color: Colors.teal,
            ),
            _StatCard(
              label: "Próximas Fechas",
              value: "${stats.upcomingEvents}",
              icon: LucideIcons.calendar,
              color: Colors.amber,
            ),
            _StatCard(
              label: "Facturas",
              value: "${stats.pendingInvoices}",
              icon: LucideIcons.creditCard,
              color: Colors.red,
            ),
          ].map((c) => SizedBox(width: width, child: c)).toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 16),
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: context.colors.mutedForeground,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveMattersTable extends StatelessWidget {
  final List<Matter> matters;
  final VoidCallback onViewAll;
  const _ActiveMattersTable({required this.matters, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Asuntos Activos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text("Ver todos"),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: matters.length.clamp(0, 5),
            itemBuilder: (context, i) {
              final m = matters[i];
              return ListTile(
                title: Text(m.title),
                subtitle: Text(m.referenceCode),
                trailing: const Icon(LucideIcons.chevronRight, size: 16),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final Future<List<PortalMessage>> Function() messagesLoader;
  final VoidCallback onViewAll;

  const _MessagesList({required this.messagesLoader, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mensajes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: onViewAll, child: const Text("Ver todos")),
            ],
          ),
          const SizedBox(height: 16),
          FutureResultView<List<PortalMessage>>(
            loader: messagesLoader,
            builder: (ctx, messages) {
              if (messages.isEmpty) {
                return const AppEmptyState(message: 'No tienes mensajes.');
              }
              return Column(
                children: messages
                    .map((m) => DashboardMessageRow(message: m))
                    .toList(),
              );
            },
            loadingBuilder: (ctx) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  final Future<List<CalendarEvent>> Function() eventsLoader;

  final Future<List<Task>> Function()? tasksDueLoader;
  final VoidCallback onViewAll;

  const _CalendarWidget({
    required this.eventsLoader,
    this.tasksDueLoader,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Calendario",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: onViewAll, child: const Text("Ver todos")),
            ],
          ),
          const SizedBox(height: 16),
          FutureResultView<List<CalendarEvent>>(
            loader: eventsLoader,
            builder: (ctx, events) {
              if (events.isEmpty) {
                return const AppEmptyState(message: 'Sin eventos próximos.');
              }
              return Column(
                children: events
                    .take(5)
                    .map((e) => DashboardEventRow(event: e))
                    .toList(),
              );
            },
            loadingBuilder: (ctx) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          if (tasksDueLoader != null) ...[
            const SizedBox(height: 20),
            const Text(
              "Tareas próximas",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureResultView<List<Task>>(
              loader: tasksDueLoader!,
              builder: (ctx, tasks) {
                if (tasks.isEmpty) {
                  return const AppEmptyState(message: 'Sin tareas próximas.');
                }
                return Column(
                  children: tasks
                      .take(4)
                      .map((t) => _DashboardTaskRow(task: t))
                      .toList(),
                );
              },
              loadingBuilder: (ctx) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact deadline row for the dashboard calendar card: a priority dot, the
/// task title, and a due date that turns red when overdue.
class _DashboardTaskRow extends StatelessWidget {
  final Task task;

  const _DashboardTaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    final due = task.dueDate;
    final overdue = task.isOverdue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: task.priority.textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          if (due != null) ...[
            const SizedBox(width: 8),
            Text(
              DateFormat('d MMM').format(due),
              style: TextStyle(
                fontSize: 11,
                color: overdue
                    ? const Color(0xFFDC2626)
                    : context.colors.mutedForeground,
                fontWeight: overdue ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
