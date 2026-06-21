part of '../blog_admin_view.dart';

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.busy,
    required this.onEdit,
    required this.onTogglePublish,
    required this.onToggleFeatured,
    required this.onDelete,
  });

  final BlogPost post;
  final bool busy;
  final VoidCallback onEdit;
  final VoidCallback onTogglePublish;
  final VoidCallback onToggleFeatured;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatusPill(
                label: post.isPublished ? 'Publicado' : 'Borrador',
                color: post.isPublished ? _teal : _gold,
              ),
              if (post.isFeatured)
                const _StatusPill(label: 'Destacado', color: _navy),
              _StatusPill(label: post.category, color: Colors.blueGrey),
              Text(
                post.slug,
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.mutedForeground,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _MetaLine(
                icon: LucideIcons.user,
                label: post.authorName.isEmpty ? 'Sin autor' : post.authorName,
              ),
              _MetaLine(
                icon: LucideIcons.clock,
                label: '${post.readMinutes} min lectura',
              ),
              _MetaLine(
                icon: LucideIcons.calendar,
                label: _formatDate(post.publishedAt ?? post.updatedAt),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: busy ? null : onEdit,
                icon: const Icon(LucideIcons.pencil, size: 16),
                label: const Text('Editar'),
              ),
              FilledButton.icon(
                onPressed: busy ? null : onTogglePublish,
                icon: Icon(
                  post.isPublished ? LucideIcons.fileEdit : LucideIcons.send,
                  size: 16,
                ),
                label: Text(post.isPublished ? 'Pasar a borrador' : 'Publicar'),
                style: FilledButton.styleFrom(
                  backgroundColor: post.isPublished
                      ? const Color(0xFFB45309)
                      : _teal,
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: busy ? null : onToggleFeatured,
                icon: Icon(
                  post.isFeatured ? Icons.star : Icons.star_border,
                  size: 16,
                ),
                label: Text(post.isFeatured ? 'Quitar destacado' : 'Destacar'),
              ),
              OutlinedButton.icon(
                onPressed: busy ? null : onDelete,
                icon: const Icon(LucideIcons.trash2, size: 16),
                label: const Text('Eliminar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB91C1C),
                ),
              ),
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: context.colors.mutedForeground),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: context.colors.mutedForeground,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate, required this.hasPosts});

  final VoidCallback onCreate;
  final bool hasPosts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          const Icon(LucideIcons.fileSearch, size: 28, color: _navy),
          const SizedBox(height: 12),
          Text(
            hasPosts
                ? 'No hay entradas para este filtro.'
                : 'Aún no existen entradas en el blog.',
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasPosts
                ? 'Cambie de filtro o cree una nueva entrada.'
                : 'Cree la primera entrada para activar el blog público.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.mutedForeground,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(LucideIcons.plus, size: 16),
            label: const Text('Crear entrada'),
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.alertCircle,
            color: Color(0xFFB91C1C),
            size: 24,
          ),
          const SizedBox(height: 10),
          const Text(
            'No fue posible abrir la gestión del blog',
            style: TextStyle(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: context.colors.mutedForeground),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(LucideIcons.refreshCcw, size: 16),
            label: const Text('Reintentar'),
            style: FilledButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
