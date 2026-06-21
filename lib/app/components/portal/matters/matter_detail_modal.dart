// Matter detail modal: a matter's header plus its documents, events,
// invoices and recent messages, loaded on open.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/calendar_event.dart';
import '../../../../core/models/document.dart';
import '../../../../core/models/invoice.dart';
import '../../../../core/models/matter.dart';
import '../../../../core/models/portal_message.dart';
import '../../../../core/presentation/future_result_view.dart';
import '../../../../core/services/portal_service.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Aggregated records shown in a matter's detail view.
class MatterDetailData {
  final List<Document> documents;
  final List<PortalMessage> messages;
  final List<CalendarEvent> events;
  final List<Invoice> invoices;

  const MatterDetailData({
    required this.documents,
    required this.messages,
    required this.events,
    required this.invoices,
  });
}

/// Modal dialog summarising one matter and its related records.
class MatterDetailModal extends StatelessWidget {
  final Matter matter;

  /// Injectable loader (defaults to live [PortalService]); tests pass a fake.
  final Future<MatterDetailData> Function(String matterId)? loader;

  const MatterDetailModal({super.key, required this.matter, this.loader});

  static Future<MatterDetailData> _defaultLoad(String matterId) async {
    final documents = await PortalService.getDocuments(matterId: matterId);
    final messages = await PortalService.getMessages(matterId: matterId);
    final allEvents = await PortalService.getEvents();
    final allInvoices = await PortalService.getInvoices();
    return MatterDetailData(
      documents: documents,
      messages: messages,
      events: allEvents.where((e) => e.matterId == matterId).toList(),
      invoices: allInvoices.where((i) => i.matterId == matterId).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailHeader(matter: matter),
            const Divider(height: 1),
            Flexible(
              child: FutureResultView<MatterDetailData>(
                loader: () => (loader ?? _defaultLoad)(matter.id),
                builder: (ctx, data) => _DetailBody(data: data),
                loadingBuilder: (_) => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  final Matter matter;
  const _DetailHeader({required this.matter});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            matter.referenceCode,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.mutedForeground,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            matter.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          if (matter.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              matter.subtitle!,
              style: TextStyle(fontSize: 14, color: colors.mutedForeground),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(
                label: matter.matterType.displayName,
                fg: matter.matterType.textColor,
                bg: matter.matterType.bgColor,
              ),
              _Chip(
                label: matter.status.displayName,
                fg: matter.status.textColor,
                bg: matter.status.bgColor,
              ),
              if (matter.lawyerName != null)
                _Chip(
                  label: matter.lawyerName!,
                  fg: colors.mutedForeground,
                  bg: colors.secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final MatterDetailData data;
  const _DetailBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            icon: LucideIcons.folder,
            title: 'Documentos (${data.documents.length})',
            isEmpty: data.documents.isEmpty,
            emptyLabel: 'Sin documentos.',
            rows: data.documents.map((d) => _DocumentRow(document: d)).toList(),
          ),
          _Section(
            icon: LucideIcons.calendar,
            title: 'Eventos (${data.events.length})',
            isEmpty: data.events.isEmpty,
            emptyLabel: 'Sin eventos.',
            rows: data.events.map((e) => _EventRow(event: e)).toList(),
          ),
          _Section(
            icon: LucideIcons.receipt,
            title: 'Facturas (${data.invoices.length})',
            isEmpty: data.invoices.isEmpty,
            emptyLabel: 'Sin facturas.',
            rows: data.invoices.map((i) => _InvoiceRow(invoice: i)).toList(),
          ),
          _Section(
            icon: LucideIcons.messageSquare,
            title: 'Mensajes (${data.messages.length})',
            isEmpty: data.messages.isEmpty,
            emptyLabel: 'Sin mensajes.',
            rows: data.messages
                .take(3)
                .map((m) => _MessageRow(message: m))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isEmpty;
  final String emptyLabel;
  final List<Widget> rows;

  const _Section({
    required this.icon,
    required this.title,
    required this.isEmpty,
    required this.emptyLabel,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isEmpty)
            Text(
              emptyLabel,
              style: TextStyle(fontSize: 13, color: colors.mutedForeground),
            )
          else
            ...rows,
        ],
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final Document document;
  const _DocumentRow({required this.document});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: document.fileUrl == null
          ? null
          : () => launchUrl(
              Uri.parse(document.fileUrl!),
              mode: LaunchMode.externalApplication,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              document.category.icon,
              size: 16,
              color: colors.mutedForeground,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                document.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            if (document.fileUrl != null)
              const Icon(
                LucideIcons.externalLink,
                size: 14,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final CalendarEvent event;
  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            LucideIcons.calendarClock,
            size: 16,
            color: Color(0xFF1E3A8A),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            DateFormat('d MMM yyyy').format(event.eventDate),
            style: TextStyle(fontSize: 12, color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final Invoice invoice;
  const _InvoiceRow({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${invoice.invoiceNumber} · ${fmt.format(invoice.amount)} ${invoice.currency}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          _Chip(
            label: invoice.status.displayName,
            fg: invoice.status.textColor,
            bg: invoice.status.bgColor,
          ),
        ],
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  final PortalMessage message;
  const _MessageRow({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderName ??
                (message.senderType == 'lawyer' ? 'Abogado' : 'Cliente'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colors.mutedForeground,
            ),
          ),
          Text(
            message.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  const _Chip({required this.label, required this.fg, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
