// Owns the portal sidebar navigation and AI conversation history list.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/conversation.dart';
import '../../../../core/presentation/future_result_view.dart';
import '../../../../core/services/chat_service.dart';
import '../../../router.dart';

/// Renders primary portal tabs and the AI assistant conversation subsection.
class PortalSidebarNavigation extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;
  final String? selectedAiConversationId;
  final Function(String)? onAiConversationSelected;
  final VoidCallback? onNewAiChat;
  final Color navyColor;
  final Color goldColor;

  /// Override for the conversations loader (testing only).
  @visibleForTesting
  final Future<List<Conversation>> Function()? conversationsLoaderOverride;

  const PortalSidebarNavigation({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.navyColor,
    required this.goldColor,
    this.selectedAiConversationId,
    this.onAiConversationSelected,
    this.onNewAiChat,
    this.conversationsLoaderOverride,
  });

  List<_PortalNavigationItem> get _menuItems {
    return [
      const _PortalNavigationItem(
        icon: LucideIcons.layoutDashboard,
        label: "Dashboard",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.folderOpen,
        label: "Mis Asuntos",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.messageSquare,
        label: "Mensajes",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.fileText,
        label: "Documentos",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.bot,
        label: "Herramientas IA",
        badge: "Nuevo",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.creditCard,
        label: "Facturación",
      ),
      const _PortalNavigationItem(
        icon: LucideIcons.calendar,
        label: "Calendario",
      ),
      if (AppRouter.authNotifier.isAdmin)
        const _PortalNavigationItem(
          icon: LucideIcons.fileEdit,
          label: "Gestión Blog",
          badge: "Admin",
        ),
      const _PortalNavigationItem(
        icon: LucideIcons.settings,
        label: "Configuración",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppRouter.authNotifier,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        children: [
          ..._menuItems.map(
            (item) => _PortalNavItem(
              item: item,
              isActive: activeTab == item.label,
              goldColor: goldColor,
              navyColor: navyColor,
              onTap: () => onTabSelected(item.label),
            ),
          ),
          if (activeTab == 'Herramientas IA') ...[
            const SizedBox(height: 24),
            _AiHistoryHeader(goldColor: goldColor),
            const SizedBox(height: 8),
            _AiNewChatButton(
              goldColor: goldColor,
              navyColor: navyColor,
              onNewAiChat: onNewAiChat,
            ),
            const SizedBox(height: 12),
            _AiConversationList(
              selectedConversationId: selectedAiConversationId,
              onConversationSelected: onAiConversationSelected,
              loaderOverride: conversationsLoaderOverride,
            ),
          ],
        ],
      ),
    );
  }
}

class _PortalNavigationItem {
  final IconData icon;
  final String label;
  final String? badge;

  const _PortalNavigationItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

class _PortalNavItem extends StatelessWidget {
  final _PortalNavigationItem item;
  final bool isActive;
  final Color goldColor;
  final Color navyColor;
  final VoidCallback onTap;

  const _PortalNavItem({
    required this.item,
    required this.isActive,
    required this.goldColor,
    required this.navyColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: 'Abrir ${item.label}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isActive ? goldColor : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive ? navyColor : Colors.blue.shade100,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isActive ? navyColor : Colors.blue.shade100,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (item.badge != null)
                  _NavBadge(
                    badge: item.badge!,
                    isActive: isActive,
                    goldColor: goldColor,
                    navyColor: navyColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  final String badge;
  final bool isActive;
  final Color goldColor;
  final Color navyColor;

  const _NavBadge({
    required this.badge,
    required this.isActive,
    required this.goldColor,
    required this.navyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? navyColor.withValues(alpha: 0.15) : goldColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: navyColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AiHistoryHeader extends StatelessWidget {
  final Color goldColor;

  const _AiHistoryHeader({required this.goldColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            LucideIcons.messageSquare,
            color: goldColor.withValues(alpha: 0.5),
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            "HISTORIAL RECIENTE",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiNewChatButton extends StatelessWidget {
  final Color goldColor;
  final Color navyColor;
  final VoidCallback? onNewAiChat;

  const _AiNewChatButton({
    required this.goldColor,
    required this.navyColor,
    required this.onNewAiChat,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Iniciar nueva consulta de IA',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: goldColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onNewAiChat,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Row(
                children: [
                  Icon(LucideIcons.plus, color: navyColor, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Nueva Consulta",
                    style: TextStyle(
                      color: navyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AiConversationList extends StatelessWidget {
  final String? selectedConversationId;
  final Function(String)? onConversationSelected;
  final Future<List<Conversation>> Function()? loaderOverride;

  const _AiConversationList({
    required this.selectedConversationId,
    required this.onConversationSelected,
    this.loaderOverride,
  });

  @override
  Widget build(BuildContext context) {
    // Read #7 — conversations list
    return FutureResultView<List<Conversation>>(
      loader: loaderOverride ?? ChatService.getConversations,
      builder: (context, conversations) {
        if (conversations.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No hay conversaciones.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          );
        }
        return Column(
          children: conversations
              .map(
                (conversation) => _AiConversationTile(
                  conversation: conversation,
                  isSelected: conversation.id == selectedConversationId,
                  onConversationSelected: onConversationSelected,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AiConversationTile extends StatelessWidget {
  final Conversation conversation;
  final bool isSelected;
  final Function(String)? onConversationSelected;

  const _AiConversationTile({
    required this.conversation,
    required this.isSelected,
    required this.onConversationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Abrir conversación ${conversation.title}',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: InkWell(
          onTap: () => onConversationSelected?.call(conversation.id),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.messageCircle,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.white54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    conversation.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
