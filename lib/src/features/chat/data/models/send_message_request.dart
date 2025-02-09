class SendMessageRequest {
  SendMessageRequest({
    num? conversationId,
    String? content,
    List<String>? mediaUrl,
  }) {
    _conversationId = conversationId;
    _content = content;
    _mediaUrl = mediaUrl;
  }

  SendMessageRequest.fromJson(dynamic json) {
    _conversationId = json['conversation_id'];
    _content = json['content'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
  }
  num? _conversationId;
  String? _content;
  List<String>? _mediaUrl;
  SendMessageRequest copyWith({
    num? conversationId,
    String? content,
    List<String>? mediaUrl,
  }) =>
      SendMessageRequest(
        conversationId: conversationId ?? _conversationId,
        content: content ?? _content,
        mediaUrl: mediaUrl ?? _mediaUrl,
      );
  num? get conversationId => _conversationId;
  String? get content => _content;
  List<String>? get mediaUrl => _mediaUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    map['content'] = _content;
    map['media_url'] = _mediaUrl;
    return map;
  }
}
