import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toastification/toastification.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domains/blog/application/create_post_use_case.dart';
import '../../../domains/blog/application/delete_post_use_case.dart';
import '../../../domains/blog/application/load_all_posts_use_case.dart';
import '../../../domains/blog/application/set_featured_use_case.dart';
import '../../../domains/blog/application/set_published_use_case.dart';
import '../../../domains/blog/application/update_post_use_case.dart';
import '../../../domains/blog/domain/blog_post.dart';
import '../../../domains/blog/infrastructure/blog_service.dart';
import '../../router.dart';

part 'blog_admin/blog_admin_editor_dialog.dart';
part 'blog_admin/blog_admin_editor_fields.dart';
part 'blog_admin/blog_admin_format.dart';
part 'blog_admin/blog_admin_list.dart';
part 'blog_admin/blog_admin_loading.dart';
part 'blog_admin/blog_admin_post_cards.dart';

const Color _navy = Color(0xFF1E3A8A);
const Color _gold = Color(0xFFD4AF37);
const Color _teal = Color(0xFF0D9488);

class BlogAdminView extends StatefulWidget {
  const BlogAdminView({super.key});

  @override
  State<BlogAdminView> createState() => _BlogAdminViewState();
}

class _BlogAdminViewState extends State<BlogAdminView> {
  static const String _filterAll = 'todos';
  static const String _filterPublished = 'publicados';
  static const String _filterDraft = 'borradores';

  List<BlogPost> _posts = <BlogPost>[];
  bool _loading = true;
  String? _errorMessage;
  String _activeFilter = _filterAll;
  String? _busyPostId;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final result = await getIt<LoadAllPostsUseCase>()();

    if (!mounted) return;

    result.fold(
      (posts) => setState(() {
        _posts = posts;
        _loading = false;
      }),
      (failure) => setState(() {
        _loading = false;
        _errorMessage =
            'No se pudo cargar la gestión del blog. ${failure.message}';
      }),
    );
  }

  List<BlogPost> get _filteredPosts {
    final sorted = [..._posts]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    if (_activeFilter == _filterPublished) {
      return sorted.where((post) => post.isPublished).toList(growable: false);
    }
    if (_activeFilter == _filterDraft) {
      return sorted.where((post) => !post.isPublished).toList(growable: false);
    }
    return sorted;
  }

  Future<void> _openEditorDialog({BlogPost? existingPost}) async {
    final draft = await showDialog<BlogPostDraftInput>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BlogPostEditorDialog(existingPost: existingPost),
    );

    if (draft == null) return;

    _setBusy(existingPost?.id ?? 'create');

    if (existingPost == null) {
      final result = await getIt<CreatePostUseCase>()(draft);
      if (!mounted) return;
      result.fold(
        (post) => _showToast(
          draft.isPublished
              ? 'Entrada creada y publicada.'
              : 'Entrada guardada como borrador.',
          ToastificationType.success,
        ),
        (failure) => _showToast(
          'No se pudo guardar la entrada. ${failure.message}',
          ToastificationType.error,
        ),
      );
    } else {
      final result = await getIt<UpdatePostUseCase>()(
        id: existingPost.id,
        input: draft,
        previousPublishedAt: existingPost.publishedAt,
      );
      if (!mounted) return;
      result.fold(
        (_) => _showToast(
          'Entrada actualizada correctamente.',
          ToastificationType.success,
        ),
        (failure) => _showToast(
          'No se pudo guardar la entrada. ${failure.message}',
          ToastificationType.error,
        ),
      );
    }

    _clearBusy();
    await _loadPosts();
  }

  Future<void> _togglePublish(BlogPost post) async {
    _setBusy(post.id);

    final result = await getIt<SetPublishedUseCase>()(
      id: post.id,
      isPublished: !post.isPublished,
    );

    if (!mounted) return;

    result.fold(
      (_) => _showToast(
        post.isPublished
            ? 'Entrada enviada a borrador.'
            : 'Entrada publicada correctamente.',
        ToastificationType.success,
      ),
      (failure) => _showToast(
        'No se pudo cambiar el estado. ${failure.message}',
        ToastificationType.error,
      ),
    );

    _clearBusy();
    await _loadPosts();
  }

  Future<void> _toggleFeatured(BlogPost post) async {
    _setBusy(post.id);

    final result = await getIt<SetFeaturedUseCase>()(
      id: post.id,
      isFeatured: !post.isFeatured,
    );

    if (!mounted) return;

    result.fold(
      (_) => _showToast(
        post.isFeatured
            ? 'Entrada removida de destacados.'
            : 'Entrada marcada como destacada.',
        ToastificationType.success,
      ),
      (failure) => _showToast(
        'No se pudo actualizar destacado. ${failure.message}',
        ToastificationType.error,
      ),
    );

    _clearBusy();
    await _loadPosts();
  }

  Future<void> _confirmDelete(BlogPost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar entrada'),
        content: Text(
          'Esta acción eliminará "${post.title}" de forma permanente. ¿Desea continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    _setBusy(post.id);

    final result = await getIt<DeletePostUseCase>()(post.id);

    if (!mounted) return;

    result.fold(
      (_) => _showToast('Entrada eliminada.', ToastificationType.success),
      (failure) => _showToast(
        'No se pudo eliminar la entrada. ${failure.message}',
        ToastificationType.error,
      ),
    );

    _clearBusy();
    await _loadPosts();
  }

  void _setBusy(String postId) {
    if (!mounted) return;
    setState(() => _busyPostId = postId);
  }

  void _clearBusy() {
    if (!mounted) return;
    setState(() => _busyPostId = null);
  }

  void _showToast(String message, ToastificationType type) {
    toastification.show(
      context: context,
      type: type,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListenableBuilder(
      listenable: AppRouter.authNotifier,
      builder: (context, _) {
        if (!AppRouter.authNotifier.isAdmin) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.shieldAlert,
                  color: Color(0xFFB91C1C),
                  size: 26,
                ),
                SizedBox(height: 12),
                Text(
                  'Acceso restringido',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Solo administradores pueden gestionar nuevas entradas del blog.',
                  style: TextStyle(fontSize: 14, height: 1.45),
                ),
              ],
            ),
          );
        }

        if (_loading) {
          return const _BlogAdminLoadingState();
        }

        if (_errorMessage != null) {
          return _ErrorState(message: _errorMessage!, onRetry: _loadPosts);
        }

        final publishedCount = _posts.where((post) => post.isPublished).length;
        final draftCount = _posts.length - publishedCount;
        final featuredCount = _posts.where((post) => post.isFeatured).length;
        final filtered = _filteredPosts;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                totalPosts: _posts.length,
                onNewPost: () => _openEditorDialog(),
                onRefresh: _loadPosts,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    label: 'Publicados',
                    value: publishedCount.toString(),
                    icon: LucideIcons.checkCircle,
                    color: _teal,
                  ),
                  _StatCard(
                    label: 'Borradores',
                    value: draftCount.toString(),
                    icon: LucideIcons.fileEdit,
                    color: _gold,
                  ),
                  _StatCard(
                    label: 'Destacados',
                    value: featuredCount.toString(),
                    icon: LucideIcons.star,
                    color: _navy,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _FilterBar(
                activeFilter: _activeFilter,
                onFilterChanged: (value) =>
                    setState(() => _activeFilter = value),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                _EmptyState(
                  onCreate: () => _openEditorDialog(),
                  hasPosts: _posts.isNotEmpty,
                )
              else
                ...filtered.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PostCard(
                      post: post,
                      busy: _busyPostId == post.id,
                      onEdit: () => _openEditorDialog(existingPost: post),
                      onTogglePublish: () => _togglePublish(post),
                      onToggleFeatured: () => _toggleFeatured(post),
                      onDelete: () => _confirmDelete(post),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
