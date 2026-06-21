// Composes the authenticated portal sidebar from focused presentation widgets.

import 'package:flutter/material.dart';

import 'sidebar/portal_sidebar_footer.dart';
import 'sidebar/portal_sidebar_navigation.dart';
import 'sidebar/portal_sidebar_profile.dart';

/// Portal navigation shell used by the authenticated desktop and mobile views.
class PortalSidebar extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;
  final VoidCallback onLogout;
  final bool isMobile;
  final String? selectedAiConversationId;
  final Function(String)? onAiConversationSelected;
  final VoidCallback? onNewAiChat;

  const PortalSidebar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.onLogout,
    this.isMobile = false,
    this.selectedAiConversationId,
    this.onAiConversationSelected,
    this.onNewAiChat,
  });

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF1E3A8A);
    const goldColor = Color(0xFFD4AF37);

    return Container(
      color: navyColor,
      child: Column(
        children: [
          const PortalSidebarProfile(
            navyColor: navyColor,
            goldColor: goldColor,
          ),
          Expanded(
            child: PortalSidebarNavigation(
              activeTab: activeTab,
              onTabSelected: onTabSelected,
              selectedAiConversationId: selectedAiConversationId,
              onAiConversationSelected: onAiConversationSelected,
              onNewAiChat: onNewAiChat,
              navyColor: navyColor,
              goldColor: goldColor,
            ),
          ),
          PortalSidebarFooter(onLogout: onLogout),
        ],
      ),
    );
  }
}
