// Coordinates portal messaging state while delegating rendering to components.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../../../core/models/matter.dart';
import '../../../core/models/portal_message.dart';
import '../../../core/services/portal_service.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../router.dart';
import 'messages/messages_empty_state.dart';
import 'messages/messages_sidebar.dart';
import 'messages/messages_thread_panel.dart';

/// Portal page for matter-scoped client-attorney messaging.
class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  String? _selectedMatterId;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PlatformFile? _pendingAttachment;
  bool _isUploadingAttachment = false;

  /// Returns a fresh loader each call — FutureResultView stores the loader,
  /// so calling setState triggers a rebuild + re-fetch (retry semantics).
  Future<List<Matter>> _mattersLoader() => PortalService.getChatMatters();

  Future<List<PortalMessage>> Function()? _messagesLoader;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectMatter(String matterId) {
    setState(() {
      _selectedMatterId = matterId;
      _messagesLoader = () => PortalService.getMessages(matterId: matterId);
    });
  }

  Future<void> _sendMessage() async {
    final matterId = _selectedMatterId;
    if (matterId == null) return;

    final content = _messageController.text.trim();
    final attachment = _pendingAttachment;
    if (content.isEmpty && attachment == null) return;

    String? attachmentUrl;
    String? attachmentName;

    if (attachment != null) {
      setState(() => _isUploadingAttachment = true);
      try {
        attachmentName = attachment.name;
        attachmentUrl = await PortalService.uploadMessageAttachment(attachment);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isUploadingAttachment = false);
        toastification.show(
          context: context,
          title: const Text('Error al subir archivo'),
          type: ToastificationType.error,
        );
        return;
      }
    }

    _messageController.clear();

    try {
      await PortalService.sendPortalMessage(
        content: content.isEmpty
            ? (attachmentName ?? 'Archivo adjunto')
            : content,
        matterId: matterId,
        attachmentUrl: attachmentUrl,
        attachmentName: attachmentName,
      );
      if (!mounted) return;
      setState(() {
        _pendingAttachment = null;
        _isUploadingAttachment = false;
      });
      _refreshMessages();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploadingAttachment = false);
      toastification.show(
        context: context,
        title: const Text('Error al enviar mensaje'),
        type: ToastificationType.error,
      );
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty && mounted) {
        setState(() => _pendingAttachment = result.files.first);
      }
    } catch (e) {
      if (!mounted) return;
      toastification.show(
        context: context,
        title: const Text('Error al seleccionar archivo'),
        type: ToastificationType.error,
      );
    }
  }

  /// Opens a picker so the user can start a conversation on one of their
  /// matters (threads are matter-scoped).
  Future<void> _showComposePicker() async {
    List<Matter> matters;
    try {
      matters = await PortalService.getChatMatters();
    } catch (e) {
      if (!mounted) return;
      toastification.show(
        context: context,
        title: const Text('No se pudieron cargar los asuntos'),
        type: ToastificationType.error,
      );
      return;
    }
    if (!mounted) return;
    if (matters.isEmpty) {
      toastification.show(
        context: context,
        title: const Text('Aún no tienes asuntos para conversar'),
        type: ToastificationType.info,
      );
      return;
    }

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Nueva conversación'),
        children: [
          for (final m in matters)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(m.id),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(m.title),
                subtitle: Text(m.referenceCode),
              ),
            ),
        ],
      ),
    );
    if (selected != null && mounted) _selectMatter(selected);
  }

  void _refreshMessages() {
    if (_selectedMatterId == null) return;
    final matterId = _selectedMatterId!;
    setState(() {
      // Re-assigning forces FutureResultView to call its loader again.
      _messagesLoader = () => PortalService.getMessages(matterId: matterId);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initiateCall({required bool video}) async {
    if (_selectedMatterId == null) return;
    try {
      await PortalService.startCall(matterId: _selectedMatterId!, video: video);
      if (!mounted) return;
      _refreshMessages();
    } catch (e) {
      if (!mounted) return;
      toastification.show(
        context: context,
        title: const Text('Error al iniciar llamada'),
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final colors = context.colors;

    return Container(
      height: MediaQuery.of(context).size.height - 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          MessagesSidebar(
            mattersLoader: _mattersLoader,
            selectedMatterId: _selectedMatterId,
            isDesktop: isDesktop,
            onMatterSelected: _selectMatter,
            onCompose: _showComposePicker,
          ),
          Expanded(
            child: _selectedMatterId == null
                ? const MessagesEmptyState()
                : MessagesThreadPanel(
                    mattersLoader: _mattersLoader,
                    messagesLoader: _messagesLoader,
                    selectedMatterId: _selectedMatterId!,
                    currentUserId: AppRouter.authNotifier.currentUser?.id,
                    messageController: _messageController,
                    scrollController: _scrollController,
                    onSendMessage: _sendMessage,
                    onStartVoiceCall: () => _initiateCall(video: false),
                    onStartVideoCall: () => _initiateCall(video: true),
                    onPickAttachment: _pickAttachment,
                    onClearAttachment: () =>
                        setState(() => _pendingAttachment = null),
                    pendingAttachmentName: _pendingAttachment?.name,
                    isUploadingAttachment: _isUploadingAttachment,
                  ),
          ),
        ],
      ),
    );
  }
}
