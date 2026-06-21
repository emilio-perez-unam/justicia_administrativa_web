import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/matter.dart';
import '../models/portal_message.dart';
import '../models/calendar_event.dart';
import '../models/portal_stats.dart';
import '../models/task.dart';
import '../models/document.dart';
import '../models/invoice.dart';

class PortalService {
  static final _client = Supabase.instance.client;

  static String? get _userId => _client.auth.currentUser?.id;

  static Future<PortalStats> getStats() async {
    final data = await _client.rpc(
      'get_portal_stats',
      params: {'p_user_id': _userId},
    );
    return PortalStats.fromJson(data as Map<String, dynamic>);
  }

  static Future<List<Matter>> getMatters() async {
    final data = await _client
        .from('matters')
        .select('*, lawyers(full_name, title, avatar_url)')
        .order('last_update', ascending: false);
    return (data as List)
        .map((e) => Matter.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Matter>> getChatMatters() async {
    final data = await _client
        .from('matters')
        .select('*, lawyers(full_name, title, avatar_url)')
        .or('client_id.eq.$_userId,lawyer_id.eq.$_userId')
        .order('last_update', ascending: false);
    return (data as List)
        .map((e) => Matter.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<PortalMessage>> getRecentMessages({int limit = 5}) async {
    final data = await _client
        .from('portal_messages_with_sender')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return (data as List)
        .map((e) => PortalMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<PortalMessage>> getMessages({String? matterId}) async {
    var query = _client.from('portal_messages_with_sender').select();
    if (matterId != null) query = query.eq('matter_id', matterId);
    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((e) => PortalMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Launch a VoIP or Video call using self-hosted MiroTalk P2P
  static Future<void> startCall({
    required String matterId,
    bool video = true,
  }) async {
    final roomName = 'JusticI_${matterId.replaceAll('-', '').substring(0, 8)}';
    final uri = Uri.parse(
      'https://meet.justiciadministrativa.com/join/$roomName',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      await sendPortalMessage(
        content:
            '📞 He iniciado una ${video ? "videollamada" : "llamada de voz"}. Únete de forma segura aquí: $uri',
        matterId: matterId,
      );
    } else {
      throw Exception('No se pudo iniciar la llamada');
    }
  }

  static Future<List<CalendarEvent>> getUpcomingEvents({int limit = 10}) async {
    final data = await _client
        .from('calendar_events')
        .select('*, matters(title)')
        .gte('event_date', DateTime.now().toIso8601String())
        .order('event_date', ascending: true)
        .limit(limit);
    return (data as List)
        .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Task>> getTasks({String? assigneeFilter}) async {
    var query = _client.from('tasks').select().inFilter('status', [
      'pendiente',
      'en_progreso',
    ]);
    if (assigneeFilter != null) {
      query = query.eq('assignee_name', assigneeFilter);
    }
    final data = await query.order(
      'due_date',
      ascending: true,
      nullsFirst: false,
    );
    return (data as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Specific method for calendar to get tasks in range
  static Future<List<Task>> getTasksForCalendar({
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _client.from('tasks').select();
    if (start != null) {
      query = query.gte('due_date', start.toIso8601String());
    }
    if (end != null) {
      query = query.lte('due_date', end.toIso8601String());
    }

    // RLS will ensure user only sees their assigned tasks
    final data = await query.order('due_date', ascending: true);
    return (data as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> completeTask(String id) async {
    await _client
        .from('tasks')
        .update({
          'status': 'completada',
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  static Future<void> updateTaskStatus(String id, String status) async {
    final updates = <String, dynamic>{'status': status};
    if (status == 'completada') {
      updates['completed_at'] = DateTime.now().toIso8601String();
    } else {
      updates['completed_at'] = null;
    }
    await _client.from('tasks').update(updates).eq('id', id);
  }

  static Future<List<Task>> getTasksDueSoon({int days = 30}) async {
    final now = DateTime.now();
    final end = now.add(Duration(days: days));
    final data = await _client
        .from('tasks')
        .select()
        .inFilter('status', ['pendiente', 'en_progreso'])
        .not('due_date', 'is', null)
        .gte('due_date', now.toIso8601String())
        .lte('due_date', end.toIso8601String())
        .order('due_date', ascending: true);
    return (data as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Document>> getDocuments({String? matterId}) async {
    var query = _client.from('documents').select();
    if (matterId != null) query = query.eq('matter_id', matterId);
    final data = await query.order('created_at', ascending: false);
    return (data as List)
        .map((e) => Document.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<Invoice>> getInvoices() async {
    final data = await _client
        .from('invoices')
        .select()
        .order('due_date', ascending: false);
    return (data as List)
        .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<CalendarEvent>> getEvents({
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _client.from('calendar_events').select('*, matters(title)');
    if (start != null) {
      query = query.gte('event_date', start.toIso8601String());
    }
    if (end != null) {
      query = query.lte('event_date', end.toIso8601String());
    }
    final data = await query.order('event_date', ascending: true);
    return (data as List)
        .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> uploadDocument({
    required PlatformFile file,
    required DocumentCategory category,
    String? matterId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final path = '${user.id}/$fileName';

    if (kIsWeb) {
      await _client.storage
          .from('clients')
          .uploadBinary(
            path,
            file.bytes!,
            fileOptions: FileOptions(
              contentType: file.extension != null
                  ? 'application/${file.extension}'
                  : null,
            ),
          );
    } else {
      if (file.path != null) {
        await _client.storage.from('clients').upload(path, File(file.path!));
      } else if (file.bytes != null) {
        await _client.storage.from('clients').uploadBinary(path, file.bytes!);
      }
    }

    final url = _client.storage.from('clients').getPublicUrl(path);

    await _client.from('documents').insert({
      'client_id': user.id,
      'matter_id': matterId,
      'name': file.name,
      'file_url': url,
      'file_size': file.size,
      'mime_type': file.extension,
      'category': category.dbValue,
      'uploaded_by': user.id,
    });
  }

  static Future<void> sendPortalMessage({
    required String content,
    required String matterId,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user');

    await _client.from('portal_messages').insert({
      'sender_id': user.id,
      'sender_type': 'client',
      'matter_id': matterId,
      'content': content,
      'attachment_url': attachmentUrl,
      'attachment_name': attachmentName,
    });
  }

  static Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String eventType,
    String? matterId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user');

    await _client.from('calendar_events').insert({
      'client_id': user.id,
      'title': title,
      'description': description,
      'event_date': date.toIso8601String(),
      'event_type': eventType,
      'matter_id': matterId,
    });
  }

  /// Uploads [file] to the public `clients` bucket under the user's messages
  /// folder and returns its public URL, for attaching to a portal message.
  static Future<String> uploadMessageAttachment(PlatformFile file) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final path = '${user.id}/messages/$fileName';

    if (kIsWeb) {
      await _client.storage
          .from('clients')
          .uploadBinary(
            path,
            file.bytes!,
            fileOptions: FileOptions(
              contentType: file.extension != null
                  ? 'application/${file.extension}'
                  : null,
            ),
          );
    } else if (file.path != null) {
      await _client.storage.from('clients').upload(path, File(file.path!));
    } else if (file.bytes != null) {
      await _client.storage.from('clients').uploadBinary(path, file.bytes!);
    }

    return _client.storage.from('clients').getPublicUrl(path);
  }

  /// Creates a new matter for the current client (client-requested intake).
  ///
  /// RLS permits a client to insert a matter where `client_id = auth.uid()`.
  /// The reference code is auto-generated with a `SOL-` (solicitud) prefix; the
  /// firm reassigns a formal code when it takes the matter on.
  static Future<void> createMatter({
    required String title,
    required String matterType,
    String? subtitle,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user');

    final now = DateTime.now();
    final reference =
        'SOL-${now.year}-'
        '${(now.millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';

    await _client.from('matters').insert({
      'client_id': user.id,
      'reference_code': reference,
      'title': title,
      'subtitle': subtitle,
      'matter_type': matterType,
      'status': 'en_proceso',
    });
  }
}
