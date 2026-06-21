// Filters and renders the portal matters collection as slivers.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/presentation/future_result_view.dart';
import '../../../../core/services/fuzzy_search_service.dart';
import 'matter_card.dart';

/// Sliver list for portal matters, including loading, empty, and error states.
///
/// [mattersLoader] is the injectable loader that fetches (and indexes) the raw
/// matters list. It is re-invoked when the user taps "Reintentar", so retry
/// performs a real re-fetch. Tests pass a throwing loader to exercise the error
/// path.
class MattersList extends StatelessWidget {
  final Future<List<Matter>> Function() mattersLoader;
  final FuzzySearchService fuzzySearch;
  final String searchQuery;
  final String statusFilter;
  final ValueChanged<Matter> onPreviewReport;
  final ValueChanged<Matter> onShowDetail;

  /// Bumping this from the parent recreates the view, forcing a fresh fetch
  /// (e.g. after a new matter is created).
  final int reloadToken;

  const MattersList({
    super.key,
    required this.mattersLoader,
    required this.fuzzySearch,
    required this.searchQuery,
    required this.statusFilter,
    required this.onPreviewReport,
    required this.onShowDetail,
    this.reloadToken = 0,
  });

  @override
  Widget build(BuildContext context) {
    // FutureResultView returns a non-sliver widget; wrap in SliverToBoxAdapter
    // so it integrates with the parent CustomScrollView.
    return SliverToBoxAdapter(
      child: FutureResultView<List<Matter>>(
        // A changing reloadToken recreates the view to force a fresh fetch;
        // "Reintentar" re-invokes the loader within the view.
        key: ValueKey(reloadToken),
        loader: mattersLoader,
        builder: (context, allMatters) {
          final filtered = _filterMatters(allMatters);
          if (filtered.isEmpty) {
            return const _NoMattersState();
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MatterCard(
                  matter: filtered[index],
                  onPreviewReport: onPreviewReport,
                  onShowDetail: onShowDetail,
                ),
              );
            },
          );
        },
        loadingBuilder: (_) => const _MattersLoadingList(),
      ),
    );
  }

  List<Matter> _filterMatters(List<Matter> allMatters) {
    // Fuzzy search is indexed in the page boundary when matters are loaded.
    final searched = searchQuery.isNotEmpty
        ? fuzzySearch.searchMatters(searchQuery)
        : allMatters;

    return searched.where((matter) {
      return statusFilter == 'Todos' ||
          matter.status.displayName == statusFilter;
    }).toList();
  }
}

class _MattersLoadingList extends StatelessWidget {
  const _MattersLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NoMattersState extends StatelessWidget {
  const _NoMattersState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.folderX, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              'No hay asuntos.',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
