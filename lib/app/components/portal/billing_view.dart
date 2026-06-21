import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../core/models/invoice.dart';
import '../../../core/presentation/future_result_view.dart';
import '../../../core/services/export_service.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../domains/billing/application/load_invoices_use_case.dart';
import '../shared/status_badge.dart';
import 'billing_stats.dart';

class BillingView extends StatefulWidget {
  /// Override for the invoices loader (testing only).
  @visibleForTesting
  final Future<List<Invoice>> Function()? invoicesLoaderOverride;

  const BillingView({super.key, this.invoicesLoaderOverride});

  @override
  State<BillingView> createState() => _BillingViewState();
}

class _BillingViewState extends State<BillingView> {
  // Lazily resolved so tests without DI setup can pump the widget.
  late final ExportService _exportService = getIt<ExportService>();

  // Re-keyed on reload to force FutureResultView to re-run the loader.
  late Key _loaderKey;

  @override
  void initState() {
    super.initState();
    _loaderKey = UniqueKey();
  }

  Future<List<Invoice>> _defaultLoader() async {
    final r = await getIt<LoadInvoicesUseCase>()();
    return r.fold((v) => v, (f) => throw f);
  }

  Future<void> _handleExport() async {
    try {
      final loader = widget.invoicesLoaderOverride ?? _defaultLoader;
      final invoices = await loader();
      if (!mounted) return;

      if (invoices.isEmpty) {
        toastification.show(
          context: context,
          title: const Text('No hay facturas para exportar'),
          type: ToastificationType.info,
        );
        return;
      }

      toastification.show(
        context: context,
        title: const Text('Generando reporte Excel...'),
        type: ToastificationType.info,
        autoCloseDuration: const Duration(seconds: 2),
      );

      await _exportService.exportInvoicesToExcel(invoices);

      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Reporte exportado exitosamente'),
          type: ToastificationType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text('Error al exportar'),
          description: Text(e.toString()),
          type: ToastificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final navyColor = const Color(0xFF1E3A8A);

    return LayoutBuilder(
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
                        "Facturación",
                        style: TextStyle(
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: navyColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _handleExport,
                        icon: const Icon(LucideIcons.fileSpreadsheet, size: 16),
                        label: const Text("Exportar Excel"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: navyColor,
                          side: BorderSide(color: navyColor),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Facturación",
                        style: TextStyle(
                          fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: navyColor,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _handleExport,
                        icon: const Icon(LucideIcons.fileSpreadsheet, size: 16),
                        label: const Text("Exportar Excel"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: navyColor,
                          side: BorderSide(color: navyColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 32),

            // Content — Read #4
            Expanded(
              child: FutureResultView<List<Invoice>>(
                key: _loaderKey,
                loader: widget.invoicesLoaderOverride ?? _defaultLoader,
                builder: (context, invoices) {
                  if (invoices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.creditCard,
                            size: 64,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 16),
                          const Text('No hay facturas.'),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        BillingStats(invoices: invoices),
                        const SizedBox(height: 32),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: invoices.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return _InvoiceCard(invoice: invoices[index]);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navyColor = const Color(0xFF1E3A8A);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.fileText, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('d MMM yyyy').format(invoice.createdAt),
                  style: TextStyle(color: colors.mutedForeground, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(symbol: '\$').format(invoice.amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: navyColor,
                ),
              ),
              const SizedBox(height: 4),
              _buildStatusBadge(invoice.status),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color;
    String label;

    switch (status) {
      case InvoiceStatus.pagada:
        color = const Color(0xFF16A34A);
        label = "Pagada";
        break;
      case InvoiceStatus.pendiente:
        color = const Color(0xFFD97706);
        label = "Pendiente";
        break;
      case InvoiceStatus.vencida:
        color = const Color(0xFFDC2626);
        label = "Vencida";
        break;
      case InvoiceStatus.cancelada:
        color = const Color(0xFF6B7280);
        label = "Cancelada";
        break;
    }

    return StatusBadge(
      label: label,
      color: color,
      child: const SizedBox.shrink(),
    );
  }
}
