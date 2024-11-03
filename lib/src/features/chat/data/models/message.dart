class MessageModel {
  MessageModel(
      {num? id,
      num? conversationId,
      num? senderId,
      dynamic content,
      String? type,
      String? status,
      dynamic mediaUrl,
      String? createdAt,
      String? updatedAt,
      String? deletedAt,
      String? senderFullName,
      String? senderAvatar}) {
    _id = id;
    _conversationId = conversationId;
    _senderId = senderId;
    _content = content;
    _type = type;
    _status = status;
    _mediaUrl = mediaUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _senderFullName = senderFullName;
    _senderAvatar = senderAvatar;
  }

  MessageModel.fromJson(dynamic json) {
    _id = json['id'];
    _conversationId = json['conversation_id'];
    _senderId = json['sender_id'];
    _content = json['content'];
    _type = json['type'];
    _status = json['status'];
    _mediaUrl = json['media_url'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _senderFullName = json['sender_full_name'];
    _senderAvatar = json['sender_avatar'];
  }
  num? _id;
  num? _conversationId;
  num? _senderId;
  dynamic _content;
  String? _type;
  String? _status;
  dynamic _mediaUrl;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  String? _senderFullName;
  String? _senderAvatar;
  MessageModel copyWith(
          {num? id,
          num? conversationId,
          num? senderId,
          dynamic content,
          String? type,
          String? status,
          dynamic mediaUrl,
          String? createdAt,
          String? updatedAt,
          String? deletedAt,
          String? senderFullName,
          String? senderAvatar}) =>
      MessageModel(
          id: id ?? _id,
          conversationId: conversationId ?? _conversationId,
          senderId: senderId ?? _senderId,
          content: content ?? _content,
          type: type ?? _type,
          status: status ?? _status,
          mediaUrl: mediaUrl ?? _mediaUrl,
          createdAt: createdAt ?? _createdAt,
          updatedAt: updatedAt ?? _updatedAt,
          deletedAt: deletedAt ?? _deletedAt,
          senderFullName: senderFullName ?? _senderFullName,
          senderAvatar: senderAvatar ?? _senderAvatar);
  num? get id => _id;
  num? get conversationId => _conversationId;
  num? get senderId => _senderId;
  dynamic get content => _content;
  String? get type => _type;
  String? get status => _status;
  dynamic get mediaUrl => _mediaUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;
  String? get senderFullName => _senderFullName;
  String? get senderAvatar => _senderAvatar;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['conversation_id'] = _conversationId;
    map['sender_id'] = _senderId;
    map['content'] = _content;
    map['type'] = _type;
    map['status'] = _status;
    map['media_url'] = _mediaUrl;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['sender_full_name'] = _senderFullName;
    map['sender_avatar'] = _senderAvatar;
    return map;
  }
}
