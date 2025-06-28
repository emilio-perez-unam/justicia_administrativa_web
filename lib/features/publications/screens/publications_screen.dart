import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justicia_administrativa_web/core/constants/colors.dart';
import 'package:justicia_administrativa_web/core/constants/spacing.dart';
import 'package:justicia_administrativa_web/core/constants/typography.dart';
import 'package:justicia_administrativa_web/features/publications/models/publication.dart';
import 'package:responsive_builder/responsive_builder.dart';

// --- MOCK DATA LAYER ---
// In a real app, this would come from a service or API
const _alfredo = Author(
  name: 'Lic. Alfredo Gutiérrez Ortiz',
  title: 'Fundador y Director General',
  imageUrl: 'assets/images/alfredo.jpg',
);

const _maria = Author(
  name: 'Lic. María Rodríguez',
  title: 'Socia, Litigio Administrativo',
  imageUrl: 'assets/images/placeholder.png',
);

const _carlos = Author(
  name: 'Ing. Carlos Mendoza',
  title: 'Director, División Tecnológica',
  imageUrl: 'assets/images/placeholder.png',
);

final allPublications = [
  Publication(
    id: '1',
    title:
        'IA y la Transformación del Derecho Administrativo en México: Perspectivas y Desafíos',
    excerpt:
        'Este artículo analiza el impacto transformador de la inteligencia artificial en la práctica del derecho administrativo iberoamericano, explorando cómo las tecnologías emergentes están redefiniendo la relación entre ciudadanos, empresas y autoridades gubernamentales.',
    author: _alfredo,
    category: 'Tecnología Legal',
    categoryColor: AppColors.techBlue,
    publishedDate: DateTime(2024, 5, 15),
    type: 'Libro',
    isFeatured: true,
    readTimeInMinutes: 12,
  ),
  Publication(
    id: '2',
    title:
        'La Nueva Ley de Procedimiento Administrativo: Implicaciones Prácticas',
    excerpt:
        'Análisis detallado de las modificaciones introducidas por la nueva legislación y su impacto en los procedimientos administrativos federales...',
    author: _maria,
    category: 'Reforma Administrativa',
    categoryColor: AppColors.accentGold,
    publishedDate: DateTime(2024, 5, 1),
    type: 'Artículo',
    readTimeInMinutes: 8,
  ),
  Publication(
    id: '3',
    title:
        'Implementación de RAG en el Análisis de Jurisprudencia Administrativa',
    excerpt:
        'Estudio sobre la aplicación de sistemas de Recuperación Aumentada por Generación (RAG) para el análisis eficiente de jurisprudencia...',
    author: _carlos,
    category: 'Tecnología Legal',
    categoryColor: AppColors.techBlue,
    publishedDate: DateTime(2024, 4, 20),
    type: 'Artículo',
    readTimeInMinutes: 10,
  ),
  Publication(
    id: '4',
    title:
        'Criterios Recientes del Tribunal Federal en Materia de Licitaciones Públicas',
    excerpt:
        'Análisis de las sentencias más relevantes emitidas por el Tribunal Federal de Justicia Administrativa durante el último año...',
    author: _alfredo,
    category: 'Casos Destacados',
    categoryColor: AppColors.primaryNavy,
    publishedDate: DateTime(2024, 3, 10),
    type: 'Opinión',
    readTimeInMinutes: 15,
  ),
];
// -- End Mock Data --

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  // State for filters would be managed here
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _HeroSection(),
          _FilterBar(
            onCategorySelected: (category) =>
                setState(() => _selectedCategory = category),
            selectedCategory: _selectedCategory,
          ),
          _FeaturedPublicationSection(
            publication: allPublications.firstWhere((p) => p.isFeatured),
          ),
          const _CategoriesSection(),
          _RecentPublicationsSection(
            publications: allPublications.where((p) => !p.isFeatured).toList(),
          ),
          _AuthorsDirectorySection(authors: [_alfredo, _maria, _carlos]),
        ],
      ),
    );
  }
}

// MARK: - Screen Sections & Widgets

class _HeroSection extends StatelessWidget {
  const _HeroSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/publications_hero.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primaryNavy,
            BlendMode.overlay,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Publicaciones Jurídicas',
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Text(
                    'Acceda a nuestra colección de artículos, libros y opiniones legales escritos por nuestros expertos en derecho administrativo y tecnología legal.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _FilterBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              ResponsiveBuilder(
                builder: (context, sizing) {
                  final isMobile = sizing.isMobile;
                  return isMobile
                      ? Column(
                          children: [
                            const TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar...',
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildDropdowns(isMobile: true),
                          ],
                        )
                      : Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Buscar publicaciones...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              flex: 3,
                              child: _buildDropdowns(isMobile: false),
                            ),
                          ],
                        );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children:
                      ['Todos', 'Reforma Administrativa', 'Tecnología Legal']
                          .map(
                            (label) => ChoiceChip(
                              label: Text(label),
                              selected: selectedCategory == label,
                              onSelected: (_) => onCategorySelected(label),
                              selectedColor: AppColors.primaryNavy,
                              labelStyle: TextStyle(
                                color: selectedCategory == label
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                              side: const BorderSide(color: AppColors.divider),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns({required bool isMobile}) {
    final dropdowns = [
      Expanded(
        child: DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(value: '1', child: Text('Todos los autores')),
          ],
          onChanged: (v) {},
          hint: const Text('Todos los autores'),
        ),
      ),
      const SizedBox(width: AppSpacing.md, height: AppSpacing.md),
      Expanded(
        child: DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(value: '1', child: Text('Todos los años')),
          ],
          onChanged: (v) {},
          hint: const Text('Todos los años'),
        ),
      ),
      const SizedBox(width: AppSpacing.md, height: AppSpacing.md),
      Expanded(
        child: DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(value: '1', child: Text('Todos los tipos')),
          ],
          onChanged: (v) {},
          hint: const Text('Todos los tipos'),
        ),
      ),
    ];
    return isMobile ? Column(children: dropdowns) : Row(children: dropdowns);
  }
}

class _FeaturedPublicationSection extends StatelessWidget {
  final Publication publication;
  const _FeaturedPublicationSection({required this.publication});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: 'Publicación Destacada'),
              const SizedBox(height: AppSpacing.lg),
              Card(
                clipBehavior: Clip.antiAlias,
                child: ScreenTypeLayout.builder(
                  mobile: (context) => Column(
                    children: [
                      _buildAuthorPanel(context),
                      _buildPublicationPanel(context),
                    ],
                  ),
                  desktop: (context) => Row(
                    children: [
                      Expanded(flex: 2, child: _buildAuthorPanel(context)),
                      Expanded(flex: 3, child: _buildPublicationPanel(context)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorPanel(BuildContext context) {
    return Container(
      color: AppColors.primaryNavy,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(publication.author.imageUrl),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication.author.name,
                      style: AppTypography.headingSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      publication.author.title,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              Chip(
                label: Text(publication.category),
                backgroundColor: AppColors.accentGold,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
              Chip(
                label: Text(publication.type),
                backgroundColor: AppColors.accentGold,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Publicado: ${DateFormat('d MMMM, yyyy', 'es_MX').format(publication.publishedDate)}',
            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tiempo de lectura: ${publication.readTimeInMinutes} minutos',
            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
          ),
          const Divider(color: Colors.white24),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('PDF'),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text('Compartir'),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(publication.title, style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          Text(publication.excerpt, style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.only(left: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.accentGold, width: 4),
              ),
            ),
            child: Text(
              '"La integración de sistemas de IA en los procesos administrativos gubernamentales representa no solo una oportunidad para mejorar la eficiencia, sino también un desafío significativo..."',
              style: AppTypography.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Leer artículo completo'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();
  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Reforma Administrativa',
        'count': 127,
        'icon': Icons.gavel,
        'color': AppColors.accentGold,
      },
      {
        'title': 'Tecnología Legal',
        'count': 45,
        'icon': Icons.computer,
        'color': AppColors.techBlue,
      },
      {
        'title': 'Casos Destacados',
        'count': 89,
        'icon': Icons.cases_sharp,
        'color': AppColors.primaryNavy,
      },
      {
        'title': 'Opiniones y Análisis',
        'count': 234,
        'icon': Icons.analytics,
        'color': AppColors.textSecondary,
      },
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: 'Categorías'),
              const SizedBox(height: AppSpacing.lg),
              ResponsiveBuilder(
                builder: (context, sizing) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: sizing.isMobile
                          ? 1
                          : (sizing.isTablet ? 2 : 4),
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: sizing.isMobile ? 2.5 : 1.5,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return _CategoryCard(
                        title: cat['title'] as String,
                        count: cat['count'] as int,
                        icon: cat['icon'] as IconData,
                        color: cat['color'] as Color,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  const _CategoryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 36, color: color),
                Chip(
                  label: Text('$count artículos'),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.headingSmall.copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Análisis de cambios legislativos y reformas al marco jurídico.',
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text('Ver publicaciones', style: TextStyle(color: color)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentPublicationsSection extends StatelessWidget {
  final List<Publication> publications;
  const _RecentPublicationsSection({required this.publications});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionHeader(title: 'Publicaciones Recientes'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 400,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: publications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 400,
                      child: _PublicationCard(publication: publications[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Ver todas las publicaciones'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublicationCard extends StatelessWidget {
  final Publication publication;
  const _PublicationCard({required this.publication});

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
                  label: Text(
                    publication.category,
                    style: AppTypography.bodySmall,
                  ),
                  backgroundColor: publication.categoryColor.withOpacity(0.1),
                ),
                const Spacer(),
                Text(
                  DateFormat(
                    'MMM yyyy',
                    'es_MX',
                  ).format(publication.publishedDate),
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              publication.title,
              style: AppTypography.headingSmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Text(
                publication.excerpt,
                style: AppTypography.bodyMedium,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(publication.author.imageUrl),
                  radius: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication.author.name,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      publication.author.title,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorsDirectorySection extends StatelessWidget {
  final List<Author> authors;
  const _AuthorsDirectorySection({required this.authors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(title: 'Directorio de Autores'),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: authors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 300,
                      child: _AuthorCard(author: authors[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorCard extends StatelessWidget {
  final Author author;
  const _AuthorCard({required this.author});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(author.imageUrl),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author.name,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(author.title, style: AppTypography.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text('42 publicaciones', style: AppTypography.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 24, color: AppColors.accentGold),
        const SizedBox(width: AppSpacing.md),
        Text(title, style: AppTypography.headingMedium),
      ],
    );
  }
}
