class UserConversation {
  UserConversation({
    num? id,
    num? userId,
    dynamic leftAt,
    num? unRead,
    String? userAvatar,
    String? userFullName,
    String? latestMessage,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _leftAt = leftAt;
    _unRead = unRead;
    _userAvatar = userAvatar;
    _userFullName = userFullName;
    _latestMessage = latestMessage;
    _updatedAt = updatedAt;
  }

  UserConversation.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _leftAt = json['left_at'];
    _unRead = json['un_read'];
    _userAvatar = json['user_avatar'];
    _userFullName = json['user_full_name'];
    _latestMessage = json['latest_message'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _userId;
  dynamic _leftAt;
  num? _unRead;
  String? _userAvatar;
  String? _userFullName;
  String? _latestMessage;
  String? _updatedAt;
  UserConversation copyWith({
    num? id,
    num? userId,
    dynamic leftAt,
    num? unRead,
    String? userAvatar,
    String? userFullName,
    String? latestMessage,
    String? updatedAt,
  }) =>
      UserConversation(
        id: id ?? _id,
        userId: userId ?? _userId,
        leftAt: leftAt ?? _leftAt,
        unRead: unRead ?? _unRead,
        userAvatar: userAvatar ?? _userAvatar,
        userFullName: userFullName ?? _userFullName,
        latestMessage: latestMessage ?? _latestMessage,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get userId => _userId;
  dynamic get leftAt => _leftAt;
  num? get unRead => _unRead;
  String? get userAvatar => _userAvatar;
  String? get userFullName => _userFullName;
  String? get latestMessage => _latestMessage;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['left_at'] = _leftAt;
    map['un_read'] = _unRead;
    map['user_avatar'] = _userAvatar;
    map['user_full_name'] = _userFullName;
    map['latest_message'] = _latestMessage;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
