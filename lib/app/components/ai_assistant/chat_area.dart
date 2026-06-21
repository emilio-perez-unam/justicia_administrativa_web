import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:file_picker/file_picker.dart';

import 'chat/chat_composer.dart';
import 'chat/chat_drop_overlay.dart';
import 'chat/chat_message_list.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/voice_service.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/models/message.dart';
import '../../../domains/ai_consultation/application/send_consultation_message_use_case.dart';

/// AI assistant conversation surface for the live client portal.
class ChatArea extends HookConsumerWidget {
  final String? conversationId;
  final Function(String) onConversationCreated;
  final Function(List<dynamic>)? onSourcesUpdated;

  const ChatArea({
    super.key,
    this.conversationId,
    required this.onConversationCreated,
    this.onSourcesUpdated,
  });

  static const _navy = Color(0xFF1A365D);
  static const _slate50 = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = useState<List<Message>>([]);
    final isLoading = useState(false);
    final isTyping = useState(false);
    final webSearchEnabled = useState(false);
    final isUploading = useState(false);
    final isListening = useState(false);
    final isDragging = useState(false);
    final pendingAttachment = useState<PlatformFile?>(null);

    final inputController = useTextEditingController();
    final scrollController = useScrollController();
    final focusNode = useFocusNode();
    final voiceService = useMemoized(() => getIt<VoiceService>());

    useEffect(() {
      voiceService.initialize();
      if (conversationId != null) {
        isLoading.value = true;
        ChatService.getMessages(conversationId!).then((msgs) {
          messages.value = msgs;
          isLoading.value = false;
          if (msgs.isNotEmpty) {
            try {
              final lastAssistantMsg = msgs.reversed.firstWhere(
                (m) => m.role == 'assistant',
              );
              if (lastAssistantMsg.metadata != null) {
                final sources =
                    lastAssistantMsg.metadata!['sources'] as List<dynamic>?;
                if (sources != null) onSourcesUpdated?.call(sources);
              }
            } catch (error) {
              debugPrint(
                'ChatArea could not restore assistant sources: $error',
              );
            }
          }
        });
      } else {
        messages.value = [];
      }
      return null;
    }, [conversationId]);

    void scrollToBottom() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    }

    Future<void> handleFileUpload() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'png'],
          withData: true,
        );
        if (result != null) pendingAttachment.value = result.files.first;
      } catch (e) {
        if (context.mounted) {
          toastification.show(
            context: context,
            title: const Text('Error al seleccionar archivo'),
            type: ToastificationType.error,
          );
        }
      }
    }

    void handleVoice() async {
      if (isListening.value) {
        await voiceService.stopListening();
        isListening.value = false;
      } else {
        isListening.value = true;
        await voiceService.startListening(
          onResult: (text) {
            inputController.text = text;
          },
        );
        Future.delayed(const Duration(seconds: 5), () {
          if (context.mounted) isListening.value = false;
        });
      }
    }

    void handleSend([String? text]) async {
      final content = (text ?? inputController.text).trim();
      if (content.isEmpty && pendingAttachment.value == null) return;

      String? attachmentUrl;
      String? attachmentName;

      if (pendingAttachment.value != null) {
        isUploading.value = true;
        try {
          attachmentName = pendingAttachment.value!.name;
          attachmentUrl = await ChatService.uploadChatFile(
            attachmentName,
            pendingAttachment.value!.bytes!,
          );
        } catch (e) {
          if (context.mounted) {
            toastification.show(
              context: context,
              title: const Text('Error al subir archivo'),
              type: ToastificationType.error,
            );
          }
          isUploading.value = false;
          return;
        }
      }

      final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      messages.value = [
        ...messages.value,
        Message(
          id: tempId,
          role: 'user',
          content: content.isEmpty
              ? 'Archivo adjunto: $attachmentName'
              : content,
          createdAt: DateTime.now(),
        ),
      ];

      inputController.clear();
      pendingAttachment.value = null;
      isUploading.value = false;
      isTyping.value = true;
      scrollToBottom();

      final result = await getIt<SendConsultationMessageUseCase>()(
        content: content,
        conversationId: conversationId,
        webSearch: webSearchEnabled.value,
        attachmentUrl: attachmentUrl,
        attachmentName: attachmentName,
      );

      isTyping.value = false;

      result.fold(
        (response) {
          if (conversationId == null) {
            onConversationCreated(response.conversationId);
          }
          messages.value = [...messages.value, response.message];
          if (response.message.metadata != null) {
            final s = response.message.metadata!['sources'] as List<dynamic>?;
            if (s != null) onSourcesUpdated?.call(s);
          }
          scrollToBottom();
        },
        (failure) {
          // Re-enable input and preserve the typed message so the user can retry.
          inputController.text = content;
          scrollToBottom();

          if (context.mounted) {
            toastification.show(
              context: context,
              title: Text(failure.message),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 8),
              description: const Text(
                'Revisa tu conexión o inicia sesión e intenta de nuevo.',
              ),
            );
          }
        },
      );
    }

    return DropTarget(
      onDragDone: (detail) async {
        if (detail.files.isNotEmpty) {
          final xfile = detail.files.first;
          final bytes = await xfile.readAsBytes();
          pendingAttachment.value = PlatformFile(
            name: xfile.name,
            size: await xfile.length(),
            bytes: bytes,
          );
        }
      },
      onDragEntered: (_) => isDragging.value = true,
      onDragExited: (_) => isDragging.value = false,
      child: Container(
        color: _slate50,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: RepaintBoundary(
                    child: ChatMessageList(
                      messages: messages.value,
                      isLoading: isLoading.value,
                      isTyping: isTyping.value,
                      scrollController: scrollController,
                    ),
                  ),
                ),
                ChatComposer(
                  controller: inputController,
                  focusNode: focusNode,
                  onSend: handleSend,
                  onUpload: handleFileUpload,
                  onVoice: handleVoice,
                  webSearchEnabled: webSearchEnabled,
                  attachment: pendingAttachment,
                  uploading: isUploading.value,
                  listening: isListening.value,
                ),
              ],
            ),
            if (isDragging.value) const ChatDropOverlay(color: _navy),
          ],
        ),
      ),
    );
  }
}
