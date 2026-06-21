class PortalMessage {
  final String id;
  final String? matterId;
  final String senderId;
  final String senderType;
  final String content;
  final String? attachmentUrl;
  final String? attachmentName;
  final bool isRead;
  final DateTime createdAt;
  final String? matterTitle;
  final String? matterReference;
  final String? senderName;
  final String? senderAvatarUrl;

  const PortalMessage({
    required this.id,
    this.matterId,
    required this.senderId,
    required this.senderType,
    required this.content,
    this.attachmentUrl,
    this.attachmentName,
    required this.isRead,
    required this.createdAt,
    this.matterTitle,
    this.matterReference,
    this.senderName,
    this.senderAvatarUrl,
  });

  factory PortalMessage.fromJson(Map<String, dynamic> json) {
    return PortalMessage(
      id: json['id'] as String,
      matterId: json['matter_id'] as String?,
      senderId: json['sender_id'] as String,
      senderType: json['sender_type'] as String,
      content: json['content'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      attachmentName: json['attachment_name'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      matterTitle: json['matter_title'] as String?,
      matterReference: json['matter_reference'] as String?,
      senderName: json['sender_name'] as String?,
      senderAvatarUrl: json['sender_avatar_url'] as String?,
    );
  }
}
