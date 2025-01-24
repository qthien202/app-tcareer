class TestModel {
  TestModel({
    List<Data>? data,
    Response? response,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _response = response;
    _links = links;
    _meta = meta;
  }

  TestModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<Data>? _data;
  Response? _response;
  Links? _links;
  Meta? _meta;
  TestModel copyWith({
    List<Data>? data,
    Response? response,
    Links? links,
    Meta? meta,
  }) =>
      TestModel(
        data: data ?? _data,
        response: response ?? _response,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<Data>? get data => _data;
  Response? get response => _response;
  Links? get links => _links;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_response != null) {
      map['response'] = _response?.toJson();
    }
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class Meta {
  Meta({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) {
    _currentPage = currentPage;
    _from = from;
    _lastPage = lastPage;
    _links = links;
    _path = path;
    _perPage = perPage;
    _to = to;
    _total = total;
  }

  Meta.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    _from = json['from'];
    _lastPage = json['last_page'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _path = json['path'];
    _perPage = json['per_page'];
    _to = json['to'];
    _total = json['total'];
  }
  num? _currentPage;
  num? _from;
  num? _lastPage;
  List<Links>? _links;
  String? _path;
  num? _perPage;
  num? _to;
  num? _total;
  Meta copyWith({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) =>
      Meta(
        currentPage: currentPage ?? _currentPage,
        from: from ?? _from,
        lastPage: lastPage ?? _lastPage,
        links: links ?? _links,
        path: path ?? _path,
        perPage: perPage ?? _perPage,
        to: to ?? _to,
        total: total ?? _total,
      );
  num? get currentPage => _currentPage;
  num? get from => _from;
  num? get lastPage => _lastPage;
  List<Links>? get links => _links;
  String? get path => _path;
  num? get perPage => _perPage;
  num? get to => _to;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    map['from'] = _from;
    map['last_page'] = _lastPage;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['path'] = _path;
    map['per_page'] = _perPage;
    map['to'] = _to;
    map['total'] = _total;
    return map;
  }
}

class Links {
  Links({
    dynamic url,
    String? label,
    bool? active,
  }) {
    _url = url;
    _label = label;
    _active = active;
  }

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
  Links copyWith({
    dynamic url,
    String? label,
    bool? active,
  }) =>
      Links(
        url: url ?? _url,
        label: label ?? _label,
        active: active ?? _active,
      );
  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }
}

class Response {
  Response({
    String? status,
    num? code,
    num? count,
  }) {
    _status = status;
    _code = code;
    _count = count;
  }

  Response.fromJson(dynamic json) {
    _status = json['status'];
    _code = json['code'];
    _count = json['count'];
  }
  String? _status;
  num? _code;
  num? _count;
  Response copyWith({
    String? status,
    num? code,
    num? count,
  }) =>
      Response(
        status: status ?? _status,
        code: code ?? _code,
        count: count ?? _count,
      );
  String? get status => _status;
  num? get code => _code;
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['code'] = _code;
    map['count'] = _count;
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
    dynamic mediaUrl,
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
    _mediaUrl = json['media_url'];
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
  dynamic _mediaUrl;
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
    dynamic mediaUrl,
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
  dynamic get mediaUrl => _mediaUrl;
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
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['created_at'] = _createdAt;
    return map;
  }
}
