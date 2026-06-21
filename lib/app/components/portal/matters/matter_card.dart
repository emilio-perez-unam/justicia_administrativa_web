// Renders a single portal matter card and its local report-preview action.

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Card summary for one legal matter in the client portal.
class MatterCard extends StatelessWidget {
  final Matter matter;
  final ValueChanged<Matter> onPreviewReport;
  final ValueChanged<Matter> onShowDetail;

  const MatterCard({
    super.key,
    required this.matter,
    required this.onPreviewReport,
    required this.onShowDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Semantics(
      container: true,
      label:
          'Asunto ${matter.title}, expediente ${matter.referenceCode}, estado ${matter.status.displayName}',
      child: ContextMenuRegion(
        contextMenu: GenericContextMenu(
          buttonConfigs: [
            ContextMenuButtonConfig(
              'Ver Detalles',
              icon: const Icon(LucideIcons.eye, size: 18),
              onPressed: () => onShowDetail(matter),
            ),
            ContextMenuButtonConfig(
              'Visualizar Reporte',
              icon: const Icon(LucideIcons.fileText, size: 18),
              onPressed: () => onPreviewReport(matter),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
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
              _MatterCardHeader(
                matter: matter,
                onPreviewReport: onPreviewReport,
              ),
              const SizedBox(height: 16),
              Text(
                matter.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: navyColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expediente: ${matter.referenceCode}',
                style: TextStyle(
                  color: colors.mutedForeground,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _MatterCardFacts(matter: matter),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

class _MatterCardHeader extends StatelessWidget {
  final Matter matter;
  final ValueChanged<Matter> onPreviewReport;

  const _MatterCardHeader({
    required this.matter,
    required this.onPreviewReport,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: matter.matterType.bgColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            matter.matterType.displayName.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: matter.matterType.textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.printer, size: 18),
              color: colors.mutedForeground,
              tooltip: 'Visualizar Reporte',
              onPressed: () => onPreviewReport(matter),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronRight,
              color: colors.mutedForeground,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
}

class _MatterCardFacts extends StatelessWidget {
  final Matter matter;

  const _MatterCardFacts({required this.matter});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MatterInfoColumn(
          label: 'ESTADO',
          value: matter.status.displayName,
          valueColor: matter.status.textColor,
        ),
        _MatterInfoColumn(
          label: 'ACTUALIZACIÓN',
          value: DateFormat('d MMM, yyyy').format(matter.lastUpdate),
          valueColor: colors.foreground,
        ),
        if (matter.lawyerName != null)
          _MatterInfoColumn(
            label: 'ABOGADO',
            value: matter.lawyerName!,
            valueColor: navyColor,
          ),
      ],
    );
  }
}

class _MatterInfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MatterInfoColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
