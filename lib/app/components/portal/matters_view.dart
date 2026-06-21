// Coordinates portal matter state while delegating rendering to focused widgets.

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/models/matter.dart';
import '../../../core/services/fuzzy_search_service.dart';
import '../../../core/services/report_service.dart';
import '../../../domains/matters/application/load_matters_use_case.dart';
import '../shared/pdf_preview_modal.dart';
import 'matters/matter_detail_modal.dart';
import 'matters/matters_filter_bar.dart';
import 'matters/matters_list.dart';
import 'matters/matters_page_header.dart';
import 'matters/new_matter_dialog.dart';

/// Portal page for browsing, filtering, and previewing client matters.
class MattersView extends StatefulWidget {
  const MattersView({super.key});

  @override
  State<MattersView> createState() => _MattersViewState();
}

class _MattersViewState extends State<MattersView> {
  final TextEditingController _searchController = TextEditingController();
  final FuzzySearchService _fuzzySearch = getIt<FuzzySearchService>();

  String _searchQuery = '';
  String _statusFilter = 'Todos';
  int _reloadToken = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      EasyDebounce.debounce(
        'matters_search',
        const Duration(milliseconds: 300),
        () => setState(() => _searchQuery = _searchController.text),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches matters and (re)builds the fuzzy-search index. Passed as the
  /// loader to [MattersList] so a "Reintentar" tap re-fetches and re-indexes.
  Future<List<Matter>> _loadMatters() async {
    final r = await getIt<LoadMattersUseCase>()();
    return r.fold((list) {
      _fuzzySearch.indexMatters(list);
      return list;
    }, (f) => throw f);
  }

  void _selectStatus(String status) {
    setState(() => _statusFilter = status);
  }

  void _showPreview(Matter matter) {
    showDialog(
      context: context,
      builder: (context) => PdfPreviewModal(
        title: 'Reporte del Caso - ${matter.referenceCode}',
        buildPdf: () => ReportService.generateMatterReportBytes(matter),
      ),
    );
  }

  void _showDetail(Matter matter) {
    showDialog<void>(
      context: context,
      builder: (_) => MatterDetailModal(matter: matter),
    );
  }

  Future<void> _showNewMatter() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => const NewMatterDialog(),
    );
    if (created == true && mounted) {
      setState(() => _reloadToken++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MattersPageHeader(
                isMobile: isMobile,
                onNewMatter: _showNewMatter,
              ),
            ),
            SliverPinnedHeader(
              child: MattersFilterBar(
                searchController: _searchController,
                selectedStatus: _statusFilter,
                isMobile: isMobile,
                onStatusSelected: _selectStatus,
              ),
            ),
            MattersList(
              mattersLoader: _loadMatters,
              fuzzySearch: _fuzzySearch,
              searchQuery: _searchQuery,
              statusFilter: _statusFilter,
              onPreviewReport: _showPreview,
              onShowDetail: _showDetail,
              reloadToken: _reloadToken,
            ),
          ],
        );
      },
    );
  }
}
