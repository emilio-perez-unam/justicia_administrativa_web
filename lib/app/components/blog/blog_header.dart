part of '../blog.dart';

class _BlogHeader extends StatelessWidget {
  const _BlogHeader({
    required this.searchController,
    required this.query,
    required this.onClearSearch,
    required this.resultCount,
    required this.activeCategory,
    required this.totalCount,
  });

  final TextEditingController searchController;
  final String query;
  final VoidCallback? onClearSearch;
  final int resultCount;
  final String activeCategory;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final showFiltersSummary =
        query.isNotEmpty || activeCategory != _allCategory;
    final countLabel = totalCount == 0
        ? 'Sin artículos publicados todavía'
        : '$resultCount de $totalCount artículos';

    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 780;

          return Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isDesktop
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blog Legal',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontFamily:
                                GoogleFonts.playfairDisplay().fontFamily,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Análisis, estrategia y tecnología para derecho administrativo moderno.',
                      style: TextStyle(
                        color: colors.mutedForeground,
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      countLabel,
                      style: TextStyle(
                        color: colors.mutedForeground,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (showFiltersSummary) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Filtro: $activeCategory${query.isEmpty ? '' : ' · "$query"'}',
                        style: TextStyle(
                          color: _navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isDesktop) const SizedBox(height: 20),
              SizedBox(
                width: isDesktop ? 320 : double.infinity,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por título, tema o autor...',
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                    suffixIcon: onClearSearch == null
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar búsqueda',
                            onPressed: onClearSearch,
                            icon: const Icon(LucideIcons.x, size: 16),
                          ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: colors.card,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.colors.radiusMd,
                      ),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.colors.radiusMd,
                      ),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.colors.radiusMd,
                      ),
                      borderSide: const BorderSide(color: _navy),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlogCategoryTabs extends StatelessWidget {
  const _BlogCategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: category == activeCategory,
                  onSelected: (_) => onSelected(category),
                  selectedColor: _navy,
                  backgroundColor: colors.secondary.withValues(alpha: 0.35),
                  labelStyle: TextStyle(
                    color: category == activeCategory
                        ? Colors.white
                        : colors.mutedForeground,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: category == activeCategory ? _navy : colors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
