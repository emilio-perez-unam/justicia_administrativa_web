import 'dart:convert';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../di/dependency_injection.dart';
import '../models/conversation.dart';
import '../models/message.dart';

class ChatResponse {
  final String conversationId;
  final Message message;

  const ChatResponse({required this.conversationId, required this.message});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversation_id'] as String,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
    );
  }
}

class ChatService {
  static final _client = getIt<SupabaseClient>();

  static Future<ChatResponse> sendMessage({
    required String content,
    String? conversationId,
    bool webSearch = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    final res = await _client.functions.invoke(
      'chat',
      body: {
        'content': content,
        if (conversationId != null) 'conversation_id': conversationId,
        'web_search': webSearch,
        if (attachmentUrl != null) 'attachment_url': attachmentUrl,
        if (attachmentName != null) 'attachment_name': attachmentName,
      },
    );

    if (res.status != 200) {
      final body = res.data is String ? res.data : jsonEncode(res.data);
      throw Exception('Chat error (${res.status}): $body');
    }

    final data = res.data is Map<String, dynamic>
        ? res.data as Map<String, dynamic>
        : jsonDecode(res.data as String) as Map<String, dynamic>;

    return ChatResponse.fromJson(data);
  }

  static Future<String> uploadChatFile(String fileName, List<int> bytes) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final path =
        '${user.id}/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await _client.storage
        .from('chat-attachments')
        .uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return _client.storage.from('chat-attachments').getPublicUrl(path);
  }

  static Future<List<Conversation>> getConversations() async {
    final data = await _client
        .from('conversations')
        .select()
        .order('updated_at', ascending: false);

    return (data as List)
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Message>> getMessages(String conversationId) async {
    final data = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return (data as List)
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
