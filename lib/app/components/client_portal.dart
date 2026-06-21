import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';
import 'portal/portal_sidebar.dart';
import 'portal/dashboard_view.dart';
import 'portal/matters_view.dart';
import 'portal/documents_view.dart';
import 'portal/billing_view.dart';
import 'portal/calendar_view.dart';
import 'portal/messages_view.dart';
import 'portal/settings_view.dart';
import 'portal/blog_admin_view.dart';
import '../views/ai_assistant_view.dart';
import '../router.dart';

class ClientPortal extends StatefulWidget {
  final VoidCallback onLogout;
  final String? initialTab;

  const ClientPortal({super.key, required this.onLogout, this.initialTab});

  @override
  State<ClientPortal> createState() => _ClientPortalState();
}

class _ClientPortalState extends State<ClientPortal> {
  late String _activeTab;
  String? _selectedAiConversationId;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab ?? 'Dashboard';
    if (_activeTab == 'Gestión Blog' && !AppRouter.authNotifier.isAdmin) {
      _activeTab = 'Dashboard';
    }
  }

  Widget _buildContent() {
    switch (_activeTab) {
      case 'Dashboard':
        return DashboardView(
          onNavigate: (tab) => setState(() => _activeTab = tab),
        );
      case 'Mis Asuntos':
        return const MattersView();
      case 'Mensajes':
        return const MessagesView();
      case 'Documentos':
        return const DocumentsView();
      case 'Herramientas IA':
        return AiAssistantView(
          conversationId: _selectedAiConversationId,
          onConversationCreated: (id) =>
              setState(() => _selectedAiConversationId = id),
        );
      case 'Facturación':
        return const BillingView();
      case 'Calendario':
        return const CalendarView();
      case 'Configuración':
        return const SettingsView();
      case 'Gestión Blog':
        if (AppRouter.authNotifier.isAdmin) {
          return const BlogAdminView();
        }
        return DashboardView(
          onNavigate: (tab) => setState(() => _activeTab = tab),
        );
      default:
        return DashboardView(
          onNavigate: (tab) => setState(() => _activeTab = tab),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 280,
                  child: PortalSidebar(
                    activeTab: _activeTab,
                    onTabSelected: (tab) => setState(() => _activeTab = tab),
                    onLogout: widget.onLogout,
                    selectedAiConversationId: _selectedAiConversationId,
                    onAiConversationSelected: (id) => setState(() {
                      _activeTab = 'Herramientas IA';
                      _selectedAiConversationId = id;
                    }),
                    onNewAiChat: () => setState(() {
                      _activeTab = 'Herramientas IA';
                      _selectedAiConversationId = null;
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: context.colors.background,
                    child: SafeArea(
                      child: _activeTab == 'Herramientas IA'
                          ? _buildContent() // Chat handles its own scrolling/centering
                          : SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 32,
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1200,
                                  ),
                                  child: _buildContent(),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            title: Text(
              _activeTab,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          drawer: Drawer(
            child: PortalSidebar(
              activeTab: _activeTab,
              onTabSelected: (tab) {
                setState(() => _activeTab = tab);
                Navigator.pop(context);
              },
              onLogout: widget.onLogout,
              selectedAiConversationId: _selectedAiConversationId,
              onAiConversationSelected: (id) => setState(() {
                _activeTab = 'Herramientas IA';
                _selectedAiConversationId = id;
                Navigator.pop(context);
              }),
              onNewAiChat: () => setState(() {
                _activeTab = 'Herramientas IA';
                _selectedAiConversationId = null;
                Navigator.pop(context);
              }),
            ),
          ),
          body: Container(
            color: context.colors.background,
            child: SafeArea(
              child: _activeTab == 'Herramientas IA'
                  ? _buildContent()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildContent(),
                    ),
            ),
          ),
        );
      },
    );
  }
}
