part of '../blog_admin_view.dart';

class _Header extends StatelessWidget {
  const _Header({
    required this.totalPosts,
    required this.onNewPost,
    required this.onRefresh,
  });

  final int totalPosts;
  final VoidCallback onNewPost;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 740;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: compact
                    ? constraints.maxWidth
                    : constraints.maxWidth * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestión de Blog',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _navy,
                            fontFamily:
                                GoogleFonts.playfairDisplay().fontFamily,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cree, edite y publique entradas visibles en la vista pública del blog.',
                      style: TextStyle(
                        color: context.colors.mutedForeground,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalPosts entradas registradas',
                      style: TextStyle(
                        color: context.colors.mutedForeground,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Actualizar'),
                  ),
                  FilledButton.icon(
                    onPressed: onNewPost,
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: const Text('Nueva entrada'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _navy,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.activeFilter, required this.onFilterChanged});

  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Todos',
            active: activeFilter == _BlogAdminViewState._filterAll,
            onTap: () => onFilterChanged(_BlogAdminViewState._filterAll),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Publicados',
            active: activeFilter == _BlogAdminViewState._filterPublished,
            onTap: () => onFilterChanged(_BlogAdminViewState._filterPublished),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Borradores',
            active: activeFilter == _BlogAdminViewState._filterDraft,
            onTap: () => onFilterChanged(_BlogAdminViewState._filterDraft),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? _navy : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? _navy : context.colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : context.colors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
