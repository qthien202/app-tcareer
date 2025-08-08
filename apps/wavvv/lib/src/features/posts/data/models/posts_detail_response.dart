class PostsDetailResponse {
  PostsDetailResponse({
    Data? data,
  }) {
    _data = data;
  }

  PostsDetailResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
  PostsDetailResponse copyWith({
    Data? data,
  }) =>
      PostsDetailResponse(
        data: data ?? _data,
      );
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    num? id,
    num? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    dynamic avatar,
    dynamic title,
    String? body,
    String? privacy,
    bool? liked,
    num? likeCount,
    num? commentCount,
    num? shareCount,
    List<String>? mediaUrl,
    dynamic status,
    num? sharedPostId,
    SharedPost? sharedPost,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    _id = id;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _fullName = fullName;
    _avatar = avatar;
    _title = title;
    _body = body;
    _privacy = privacy;
    _liked = liked;
    _likeCount = likeCount;
    _commentCount = commentCount;
    _shareCount = shareCount;
    _mediaUrl = mediaUrl;
    _status = status;
    _sharedPostId = sharedPostId;
    _sharedPost = sharedPost;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
    _title = json['title'];
    _body = json['body'];
    _privacy = json['privacy'];
    _liked = json['liked'];
    _likeCount = json['like_count'];
    _commentCount = json['comment_count'];
    _shareCount = json['share_count'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
    _status = json['status'];
    _sharedPostId = json['shared_post_id'];
    _sharedPost = json['shared_post'] != null
        ? SharedPost.fromJson(json['shared_post'])
        : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  num? _id;
  num? _userId;
  String? _firstName;
  String? _lastName;
  String? _fullName;
  dynamic _avatar;
  dynamic _title;
  String? _body;
  String? _privacy;
  bool? _liked;
  num? _likeCount;
  num? _commentCount;
  num? _shareCount;
  List<String>? _mediaUrl;
  dynamic _status;
  num? _sharedPostId;
  SharedPost? _sharedPost;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  Data copyWith({
    num? id,
    num? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    dynamic avatar,
    dynamic title,
    String? body,
    String? privacy,
    bool? liked,
    num? likeCount,
    num? commentCount,
    num? shareCount,
    List<String>? mediaUrl,
    dynamic status,
    num? sharedPostId,
    SharedPost? sharedPost,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) =>
      Data(
        id: id ?? _id,
        userId: userId ?? _userId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
        title: title ?? _title,
        body: body ?? _body,
        privacy: privacy ?? _privacy,
        liked: liked ?? _liked,
        likeCount: likeCount ?? _likeCount,
        commentCount: commentCount ?? _commentCount,
        shareCount: shareCount ?? _shareCount,
        mediaUrl: mediaUrl ?? _mediaUrl,
        status: status ?? _status,
        sharedPostId: sharedPostId ?? _sharedPostId,
        sharedPost: sharedPost ?? _sharedPost,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  num? get id => _id;
  num? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fullName => _fullName;
  dynamic get avatar => _avatar;
  dynamic get title => _title;
  String? get body => _body;
  String? get privacy => _privacy;
  bool? get liked => _liked;
  num? get likeCount => _likeCount;
  num? get commentCount => _commentCount;
  num? get shareCount => _shareCount;
  List<String>? get mediaUrl => _mediaUrl;
  dynamic get status => _status;
  num? get sharedPostId => _sharedPostId;
  SharedPost? get sharedPost => _sharedPost;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['title'] = _title;
    map['body'] = _body;
    map['privacy'] = _privacy;
    map['liked'] = _liked;
    map['like_count'] = _likeCount;
    map['comment_count'] = _commentCount;
    map['share_count'] = _shareCount;
    map['media_url'] = _mediaUrl;
    map['status'] = _status;
    map['shared_post_id'] = _sharedPostId;
    if (_sharedPost != null) {
      map['shared_post'] = _sharedPost?.toJson();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}

class SharedPost {
  SharedPost({
    num? id,
    String? body,
    String? privacy,
    List<String>? mediaUrl,
    num? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatar,
    String? createdAt,
  }) {
    _id = id;
    _body = body;
    _privacy = privacy;
    _mediaUrl = mediaUrl;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _fullName = fullName;
    _avatar = avatar;
    _createdAt = createdAt;
  }

  SharedPost.fromJson(dynamic json) {
    _id = json['id'];
    _body = json['body'];
    _privacy = json['privacy'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
    _createdAt = json['created_at'];
  }
  num? _id;
  String? _body;
  String? _privacy;
  List<String>? _mediaUrl;
  num? _userId;
  String? _firstName;
  String? _lastName;
  String? _fullName;
  String? _avatar;
  String? _createdAt;
  SharedPost copyWith({
    num? id,
    String? body,
    String? privacy,
    List<String>? mediaUrl,
    num? userId,
    String? firstName,
    String? lastName,
    String? fullName,
    String? avatar,
    String? createdAt,
  }) =>
      SharedPost(
        id: id ?? _id,
        body: body ?? _body,
        privacy: privacy ?? _privacy,
        mediaUrl: mediaUrl ?? _mediaUrl,
        userId: userId ?? _userId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
        createdAt: createdAt ?? _createdAt,
      );
  num? get id => _id;
  String? get body => _body;
  String? get privacy => _privacy;
  List<String>? get mediaUrl => _mediaUrl;
  num? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fullName => _fullName;
  String? get avatar => _avatar;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['body'] = _body;
    map['privacy'] = _privacy;
    map['media_url'] = _mediaUrl;
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['created_at'] = _createdAt;
    return map;
  }
}
