part of '../blog_admin_view.dart';

class _BlogAdminLoadingState extends StatelessWidget {
  const _BlogAdminLoadingState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gestión de Blog'),
                SizedBox(height: 8),
                Text(
                  'Cree, edite y publique entradas visibles en la vista pública del blog.',
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Actualizar')),
                    SizedBox(width: 12),
                    Expanded(child: Text('Nueva entrada')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _LoadingStatCard(),
              _LoadingStatCard(),
              _LoadingStatCard(),
            ],
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Todos')),
              Chip(label: Text('Publicados')),
              Chip(label: Text('Borradores')),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(
            3,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _LoadingPostCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingStatCard extends StatelessWidget {
  const _LoadingStatCard();

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Publicados'), SizedBox(height: 8), Text('12')],
      ),
    );
  }
}

class _LoadingPostCard extends StatelessWidget {
  const _LoadingPostCard();

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Publicado · Destacado · Derecho Administrativo'),
          SizedBox(height: 10),
          Text('Título de entrada en carga'),
          SizedBox(height: 6),
          Text('Extracto en proceso de carga'),
        ],
      ),
    );
  }
}
