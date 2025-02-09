class MarkReadMessageRequest {
  MarkReadMessageRequest({
    num? conversationId,
  }) {
    _conversationId = conversationId;
  }

  MarkReadMessageRequest.fromJson(dynamic json) {
    _conversationId = json['conversation_id'];
  }
  num? _conversationId;
  MarkReadMessageRequest copyWith({
    num? conversationId,
  }) =>
      MarkReadMessageRequest(
        conversationId: conversationId ?? _conversationId,
      );
  num? get conversationId => _conversationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    return map;
  }
}
