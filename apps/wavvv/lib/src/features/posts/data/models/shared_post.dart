class SharedPost {
  SharedPost({
    num? userId,
    num? id,
    String? body,
    String? privacy,
    List<String>? mediaUrl,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatar,
    String? createdAt,
  }) {
    _userId = userId;
    _id = id;
    _body = body;
    _privacy = privacy;
    _mediaUrl = mediaUrl;
    _firstName = firstName;
    _lastName = lastName;
    _fullName = fullName;
    _avatar = avatar;
    _createdAt = createdAt;
  }

  SharedPost.fromJson(dynamic json) {
    _userId = json['user_id'];
    _id = json['id'];
    _body = json['body'];
    _privacy = json['privacy'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
    _createdAt = json['created_at'];
  }
  num? _userId;
  num? _id;
  String? _body;
  String? _privacy;
  List<String>? _mediaUrl;
  String? _firstName;
  String? _lastName;
  String? _fullName;
  String? _avatar;
  String? _createdAt;
  SharedPost copyWith({
    num? userId,
    num? id,
    String? body,
    String? privacy,
    List<String>? mediaUrl,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatar,
    String? createdAt,
  }) =>
      SharedPost(
        userId: userId ?? _userId,
        id: id ?? _id,
        body: body ?? _body,
        privacy: privacy ?? _privacy,
        mediaUrl: mediaUrl ?? _mediaUrl,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
        createdAt: createdAt ?? _createdAt,
      );
  num? get id => _id;
  num? get userId => _userId;
  String? get body => _body;
  String? get privacy => _privacy;
  List<String>? get mediaUrl => _mediaUrl;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fullName => _fullName;
  String? get avatar => _avatar;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['body'] = _body;
    map['privacy'] = _privacy;
    map['media_url'] = _mediaUrl;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['created_at'] = _createdAt;
    return map;
  }
}
