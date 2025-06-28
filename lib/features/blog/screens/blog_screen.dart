import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/features/blog/models/blog_post.dart';
import 'package:responsive_builder/responsive_builder.dart';

// --- Mock Data Layer ---
// In a real app, this would come from a CMS or API
final allPosts = [
  BlogPost(
    id: '1',
    title:
        'IA y la Transformación del Derecho Administrativo en México: Análisis del Impacto Tecnológico',
    excerpt:
        'Un análisis profundo sobre cómo la inteligencia artificial está transformando la práctica del derecho administrativo en México, con casos prácticos y perspectivas de futuro.',
    imageUrl: 'assets/images/blog/featured_post.jpg', // Placeholder path
    author: const Author(
      name: 'Lic. Alfredo Gutiérrez Ortiz',
      title: 'Fundador y Director General',
      imageUrl: 'assets/images/alfredo.jpg',
    ),
    category: 'Destacado',
    categoryColor: AppColors.techBlue,
    publishedDate: DateTime(2023, 5, 5),
    readTime: 15,
    viewCount: 1200,
    commentCount: 42,
    isFeatured: true,
  ),
  BlogPost(
    id: '2',
    title:
        'Implementación de Sistemas RAG en Despachos Jurídicos: Casos de Éxito',
    excerpt:
        'Un análisis detallado de cómo los sistemas de Recuperación Aumentada por Generación (RAG) están revolucionando la gestión documental en los despachos jurídicos iberoamericanos.',
    imageUrl: 'assets/images/blog/post2.jpg',
    author: const Author(
      name: 'Ing. Daniel Moreno',
      title: 'Director de Tecnología',
      imageUrl: 'assets/images/placeholder.png',
    ),
    category: 'Tecnología Legal',
    categoryColor: AppColors.techBlue,
    publishedDate: DateTime(2023, 5, 2),
    readTime: 8,
    viewCount: 243,
    commentCount: 18,
  ),
  BlogPost(
    id: '3',
    title:
        'Análisis del Caso Pemex vs. COFECE: Implicaciones para la Competencia Económica',
    excerpt:
        'Un estudio detallado del reciente amparo ganado por Pemex contra la Comisión Federal de Competencia Económica y sus implicaciones para el sector energético iberoamericano.',
    imageUrl: 'assets/images/blog/post3.jpg',
    author: const Author(
      name: 'Lic. María Fernanda López',
      title: 'Socia - Derecho Corporativo',
      imageUrl: 'assets/images/placeholder.png',
    ),
    category: 'Análisis de Casos',
    categoryColor: AppColors.primaryNavy,
    publishedDate: DateTime(2023, 4, 28),
    readTime: 12,
    viewCount: 358,
    commentCount: 32,
  ),
  BlogPost(
    id: '4',
    title:
        'La Nueva Ley de Procedimiento Administrativo: Cambios Clave y Estrategias de Adaptación',
    excerpt:
        'Un análisis exhaustivo de las recientes modificaciones a la Ley Federal de Procedimiento Administrativo y cómo las empresas deben adaptarse para mantener el cumplimiento normativo.',
    imageUrl: 'assets/images/blog/post4.jpg',
    author: const Author(
      name: 'Lic. Alfredo Gutiérrez Ortiz',
      title: 'Fundador y Director General',
      imageUrl: 'assets/images/alfredo.jpg',
    ),
    category: 'Reforma Administrativa',
    categoryColor: AppColors.accentGold,
    publishedDate: DateTime(2023, 4, 20),
    readTime: 10,
    viewCount: 421,
    commentCount: 45,
  ),
];

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredPost = allPosts.firstWhere((p) => p.isFeatured);
    final recentPosts = allPosts.where((p) => !p.isFeatured).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const _BlogHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
              horizontal: AppSpacing.pagePadding,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Column(
                children: [
                  _FeaturedArticle(post: featuredPost),
                  const SizedBox(height: AppSpacing.xxxl),
                  ScreenTypeLayout.builder(
                    mobile: (context) =>
                        _buildMobileLayout(context, recentPosts),
                    desktop: (context) =>
                        _buildDesktopLayout(context, recentPosts),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<BlogPost> posts) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _MainContentColumn(posts: posts)),
        const SizedBox(width: AppSpacing.xl),
        const Expanded(flex: 1, child: _Sidebar()),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<BlogPost> posts) {
    return Column(
      children: [
        _MainContentColumn(posts: posts),
        const SizedBox(height: AppSpacing.xl),
        const _Sidebar(),
      ],
    );
  }
}

// MARK: - Main Layout Components
class _BlogHeader extends StatelessWidget {
  const _BlogHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: ResponsiveBuilder(
            builder: (context, sizing) {
              final isMobile = sizing.isMobile;
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: AppSpacing.md),
                        _buildSearchField(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [_buildTitle(), _buildSearchField()],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Blog Legal', style: AppTypography.headingLarge),
        Text(
          'Análisis y perspectivas sobre tecnología legal y derecho administrativo',
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: 256,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar artículos...',
          prefixIcon: const Icon(Icons.search),
          isDense: true,
        ),
      ),
    );
  }
}

class _FeaturedArticle extends StatelessWidget {
  final BlogPost post;
  const _FeaturedArticle({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ScreenTypeLayout.builder(
        mobile: (context) => Column(
          children: [
            Image.asset(
              post.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            _ArticleContent(post: post),
          ],
        ),
        desktop: (context) => Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(post.imageUrl, height: 624, fit: BoxFit.cover),
            ),
            Expanded(flex: 1, child: _ArticleContent(post: post)),
          ],
        ),
      ),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  final BlogPost post;
  const _ArticleContent({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(post.category),
                backgroundColor: post.categoryColor.withOpacity(0.1),
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: post.categoryColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                DateFormat('d MMMM, yyyy', 'es_MX').format(post.publishedDate),
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(post.title, style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          Text(post.excerpt, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          _AuthorInfo(author: post.author),
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          _ArticleActions(post: post),
        ],
      ),
    );
  }
}

class _MainContentColumn extends StatelessWidget {
  final List<BlogPost> posts;
  const _MainContentColumn({required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Artículos Recientes', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.lg),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.lg),
          itemBuilder: (context, index) =>
              _RecentArticleCard(post: posts[index]),
        ),
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Cargar más artículos'),
          ),
        ),
      ],
    );
  }
}

class _RecentArticleCard extends StatelessWidget {
  final BlogPost post;
  const _RecentArticleCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(post.category),
                  backgroundColor: post.categoryColor.withOpacity(0.1),
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: post.categoryColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  DateFormat(
                    'd MMMM, yyyy',
                    'es_MX',
                  ).format(post.publishedDate),
                  style: AppTypography.bodySmall,
                ),
                const Spacer(),
                const Icon(Icons.timer_outlined, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${post.readTime} min de lectura',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(post.title, style: AppTypography.headingSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              post.excerpt,
              style: AppTypography.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            _AuthorInfo(author: post.author),
            const Divider(height: AppSpacing.lg),
            _ArticleActions(post: post),
          ],
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSidebarCard(
          title: 'Autor Destacado',
          child: _AuthorInfo(
            author: allPosts[2].author, // Mock author
            bio:
                'Especialista en derecho corporativo con 15 años de experiencia. Experta en fusiones y adquisiciones, compliance regulatorio y contratación pública.',
          ),
        ),
        _buildSidebarCard(
          title: 'Temas Populares',
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              Chip(label: Text('Inteligencia Artificial')),
              Chip(label: Text('Amparo')),
              Chip(label: Text('Licitaciones')),
              Chip(label: Text('JusticiaGPT')),
              Chip(label: Text('Reforma 2023')),
            ],
          ),
        ),
        _buildSidebarCard(
          title: 'Más Comentados',
          child: Column(
            children: [
              _buildCommentedLink('La Nueva Ley de Procedimiento...'),
              _buildCommentedLink('Análisis del Caso Pemex vs. COFECE...'),
              _buildCommentedLink('Implementación de Sistemas RAG...'),
            ],
          ),
        ),
        _buildSidebarCard(
          title: 'Suscríbase a nuestro boletín',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reciba nuestros análisis legales semanales directamente en su correo.',
              ),
              const SizedBox(height: AppSpacing.md),
              const TextField(
                decoration: InputDecoration(hintText: 'Su correo electrónico'),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Suscribirse'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.headingSmall),
            const Divider(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCommentedLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.techBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Reusable Helper Widgets
class _AuthorInfo extends StatelessWidget {
  final Author author;
  final String? bio;

  const _AuthorInfo({required this.author, this.bio});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 24, backgroundImage: AssetImage(author.imageUrl)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author.name,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(author.title, style: AppTypography.bodySmall),
              if (bio != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(bio!, style: AppTypography.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ver perfil completo',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.techBlue,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ArticleActions extends StatelessWidget {
  final BlogPost post;
  const _ArticleActions({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
          label: Text(
            post.isFeatured ? 'Leer artículo completo' : 'Leer artículo',
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.visibility_outlined,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('${post.viewCount}', style: AppTypography.bodySmall),
        const SizedBox(width: AppSpacing.md),
        const Icon(
          Icons.chat_bubble_outline,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('${post.commentCount}', style: AppTypography.bodySmall),
      ],
    );
  }
}
