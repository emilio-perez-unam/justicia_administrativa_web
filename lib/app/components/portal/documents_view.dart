import 'package:shimmer/shimmer.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/models/document.dart';
import '../../../core/presentation/future_result_view.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domains/documents/application/load_documents_use_case.dart';
import '../../../domains/documents/application/upload_document_use_case.dart';

class DocumentsView extends StatefulWidget {
  /// Override for the documents loader (testing only).
  @visibleForTesting
  final Future<List<Document>> Function()? documentsLoaderOverride;

  const DocumentsView({super.key, this.documentsLoaderOverride});

  @override
  State<DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDragging = false;

  // Holds the current loader so FutureResultView can be re-keyed on upload.
  late Key _loaderKey;

  @override
  void initState() {
    super.initState();
    _loaderKey = UniqueKey();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  void _loadDocuments() {
    setState(() => _loaderKey = UniqueKey());
  }

  Future<List<Document>> _defaultLoader() async {
    final r = await getIt<LoadDocumentsUseCase>()();
    return r.fold((v) => v, (f) => throw f);
  }

  Future<void> _handleUpload([PlatformFile? file]) async {
    try {
      PlatformFile? fileToUpload = file;

      if (fileToUpload == null) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
          withData: true,
        );
        if (result != null) fileToUpload = result.files.first;
      }

      if (fileToUpload != null) {
        if (!mounted) return;

        toastification.show(
          context: context,
          title: const Text('Subiendo documento...'),
          type: ToastificationType.info,
          autoCloseDuration: const Duration(seconds: 2),
        );

        final result = await getIt<UploadDocumentUseCase>()(
          file: fileToUpload,
          category: DocumentCategory.otro,
        );

        if (!mounted) return;

        result.fold(
          (_) {
            toastification.show(
              context: context,
              title: const Text('Documento subido con éxito'),
              type: ToastificationType.success,
            );
            _loadDocuments();
          },
          (failure) {
            toastification.show(
              context: context,
              title: const Text('Error al subir documento'),
              description: Text(failure.message),
              type: ToastificationType.error,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Error al subir documento'),
          description: Text(e.toString()),
          type: ToastificationType.error,
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);

    return DropTarget(
      onDragDone: (detail) async {
        if (detail.files.isNotEmpty) {
          final xfile = detail.files.first;
          final bytes = await xfile.readAsBytes();
          final file = PlatformFile(
            name: xfile.name,
            size: await xfile.length(),
            bytes: bytes,
          );
          _handleUpload(file);
        }
      },
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Documentos",
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: navyColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => _handleUpload(),
                              icon: const Icon(
                                LucideIcons.uploadCloud,
                                size: 16,
                              ),
                              label: const Text("Subir Documento"),
                              style: FilledButton.styleFrom(
                                backgroundColor: navyColor,
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Documentos",
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.playfairDisplay().fontFamily,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: navyColor,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () => _handleUpload(),
                              icon: const Icon(
                                LucideIcons.uploadCloud,
                                size: 16,
                              ),
                              label: const Text("Subir Documento"),
                              style: FilledButton.styleFrom(
                                backgroundColor: navyColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 32),

                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar documento por nombre...",
                        prefixIcon: Icon(
                          LucideIcons.search,
                          size: 18,
                          color: colors.mutedForeground,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Content — Read #3
                  Expanded(
                    child: FutureResultView<List<Document>>(
                      key: _loaderKey,
                      loader: widget.documentsLoaderOverride ?? _defaultLoader,
                      builder: (context, allDocs) {
                        final filtered = allDocs
                            .where(
                              (d) =>
                                  d.name.toLowerCase().contains(_searchQuery),
                            )
                            .toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.fileX,
                                  size: 64,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 16),
                                const Text('No hay documentos.'),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 320,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                mainAxisExtent: isMobile ? 160 : 180,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _DocumentCard(document: filtered[index]);
                          },
                        );
                      },
                      loadingBuilder: (context) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          mainAxisExtent: isMobile ? 160 : 180,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (_isDragging)
            Positioned.fill(
              child: Container(
                color: navyColor.withValues(alpha: 0.1),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.uploadCloud,
                          size: 48,
                          color: navyColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Soltar archivo para subir",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: navyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final Document document;
  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);
    final fileUrl = document.fileUrl ?? '';

    return InkWell(
      onTap: () {
        if (fileUrl.isNotEmpty) {
          launchUrl(Uri.parse(fileUrl));
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.fileText,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ),
            const Spacer(),
            Text(
              document.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: navyColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d MMM yyyy').format(document.createdAt),
              style: TextStyle(color: colors.mutedForeground, fontSize: 12),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}
