part of '../blog.dart';

class _BlogLoadingState extends StatelessWidget {
  const _BlogLoadingState();

  @override
  Widget build(BuildContext context) {
    Widget buildFeedColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blog Legal',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Análisis, estrategia y tecnología para derecho administrativo moderno.',
                ),
                const SizedBox(height: 12),
                const Text('8 de 8 artículos'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Todos los artículos')),
              Chip(label: Text('Derecho Administrativo')),
              Chip(label: Text('Tecnología Legal')),
              Chip(label: Text('Estrategia')),
            ],
          ),
          const SizedBox(height: 28),
          _SkeletonPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Artículo destacado'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Título del artículo principal en carga'),
                const SizedBox(height: 8),
                const Text('Resumen del artículo principal en carga.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _SkeletonArticleCard(),
            ),
          ),
        ],
      );
    }

    Widget buildSidebar() {
      return Column(
        children: const [
          _SkeletonPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Autor destacado'),
                SizedBox(height: 10),
                Text('Perfil cargando...'),
                SizedBox(height: 6),
                Text('Biografía cargando...'),
              ],
            ),
          ),
          SizedBox(height: 14),
          _SkeletonPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Temas populares'),
                SizedBox(height: 10),
                Text('Tema 1'),
                Text('Tema 2'),
                Text('Tema 3'),
              ],
            ),
          ),
          SizedBox(height: 14),
          _SkeletonPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Más comentados'),
                SizedBox(height: 10),
                Text('Artículo en carga'),
                Text('Artículo en carga'),
                Text('Artículo en carga'),
              ],
            ),
          ),
        ],
      );
    }

    return Skeletonizer(
      enabled: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1040) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildFeedColumn(),
                const SizedBox(height: 24),
                buildSidebar(),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: buildFeedColumn()),
              const SizedBox(width: 30),
              Expanded(flex: 4, child: buildSidebar()),
            ],
          );
        },
      ),
    );
  }
}

class _SkeletonArticleCard extends StatelessWidget {
  const _SkeletonArticleCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categoría · Fecha · 7 min lectura'),
          SizedBox(height: 10),
          Text('Título de artículo en proceso de carga'),
          SizedBox(height: 6),
          Text('Extracto de contenido mostrando el estado de carga.'),
        ],
      ),
    );
  }
}

class _SkeletonPanel extends StatelessWidget {
  const _SkeletonPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusXl),
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }
}
