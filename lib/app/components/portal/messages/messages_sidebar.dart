// Renders the matter list used to choose a portal message thread.

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/matter.dart';
import '../../../../core/presentation/future_result_view.dart';
import '../../../../core/presentation/states/app_empty_state.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Sidebar for selecting the active matter conversation.
class MessagesSidebar extends StatelessWidget {
  /// Loader function — called on init and on retry so the user can recover
  /// from transient errors without a full page reload.
  final Future<List<Matter>> Function() mattersLoader;
  final String? selectedMatterId;
  final bool isDesktop;
  final ValueChanged<String> onMatterSelected;
  final VoidCallback onCompose;

  const MessagesSidebar({
    super.key,
    required this.mattersLoader,
    required this.selectedMatterId,
    required this.isDesktop,
    required this.onMatterSelected,
    required this.onCompose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const navyColor = Color(0xFF1E3A8A);

    return Container(
      width: isDesktop ? 320 : 80,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        children: [
          _MessagesSidebarHeader(isDesktop: isDesktop, onCompose: onCompose),
          const Divider(height: 1),
          Expanded(
            child: FutureResultView<List<Matter>>(
              loader: mattersLoader,
              builder: (context, matters) {
                if (matters.isEmpty) {
                  return const AppEmptyState(message: 'No hay conversaciones.');
                }
                return ListView.builder(
                  itemCount: matters.length,
                  itemBuilder: (context, index) {
                    final matter = matters[index];
                    return _ChatListTile(
                      matter: matter,
                      isSelected: matter.id == selectedMatterId,
                      isDesktop: isDesktop,
                      navyColor: navyColor,
                      onTap: () => onMatterSelected(matter.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesSidebarHeader extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onCompose;

  const _MessagesSidebarHeader({
    required this.isDesktop,
    required this.onCompose,
  });

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);

    if (!isDesktop) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: IconButton(
          icon: const Icon(LucideIcons.edit, color: navyColor),
          tooltip: 'Nueva conversación',
          onPressed: onCompose,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Mensajes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navyColor,
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.edit, color: navyColor, size: 20),
            tooltip: 'Nueva conversación',
            onPressed: onCompose,
          ),
        ],
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final Matter matter;
  final bool isSelected;
  final bool isDesktop;
  final Color navyColor;
  final VoidCallback onTap;

  const _ChatListTile({
    required this.matter,
    required this.isSelected,
    required this.isDesktop,
    required this.navyColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Abrir conversación de ${matter.title}',
      child: InkWell(
        onTap: onTap,
        child: isDesktop ? _desktopTile() : _compactTile(),
      ),
    );
  }

  Widget _compactTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      color: isSelected ? navyColor.withValues(alpha: 0.1) : null,
      child: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: Icon(LucideIcons.user, size: 18, color: navyColor),
      ),
    );
  }

  Widget _desktopTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? navyColor.withValues(alpha: 0.05) : null,
        border: isSelected
            ? Border(left: BorderSide(color: navyColor, width: 4))
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(LucideIcons.user, color: navyColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matter.title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  matter.referenceCode,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
