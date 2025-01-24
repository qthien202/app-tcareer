class LeaveChatRequest {
  LeaveChatRequest({
      num? conversationId, 
      String? time,}){
    _conversationId = conversationId;
    _time = time;
}

  LeaveChatRequest.fromJson(dynamic json) {
    _conversationId = json['conversation_id'];
    _time = json['time'];
  }
  num? _conversationId;
  String? _time;
LeaveChatRequest copyWith({  num? conversationId,
  String? time,
}) => LeaveChatRequest(  conversationId: conversationId ?? _conversationId,
  time: time ?? _time,
);
  num? get conversationId => _conversationId;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    map['time'] = _time;
    return map;
  }

}