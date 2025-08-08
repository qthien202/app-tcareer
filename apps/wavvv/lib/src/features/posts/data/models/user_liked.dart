class UserLiked {
  UserLiked({
    List<Data>? data,
    Response? response,
  }) {
    _data = data;
    _response = response;
  }

  UserLiked.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  List<Data>? _data;
  Response? _response;
  UserLiked copyWith({
    List<Data>? data,
    Response? response,
  }) =>
      UserLiked(
        data: data ?? _data,
        response: response ?? _response,
      );
  List<Data>? get data => _data;
  Response? get response => _response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_response != null) {
      map['response'] = _response?.toJson();
    }
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
    String? firstName,
    String? lastName,
    String? shortName,
    String? fullName,
    String? avatar,
    String? email,
    num? followerCount,
    num? friendCount,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _shortName = shortName;
    _fullName = fullName;
    _avatar = avatar;
    _email = email;
    _followerCount = followerCount;
    _friendCount = friendCount;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _shortName = json['short_name'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
    _email = json['email'];
    _followerCount = json['follower_count'];
    _friendCount = json['friend_count'];
  }
  num? _id;
  String? _firstName;
  String? _lastName;
  String? _shortName;
  String? _fullName;
  String? _avatar;
  String? _email;
  num? _followerCount;
  num? _friendCount;
  Data copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? shortName,
    String? fullName,
    String? avatar,
    String? email,
    num? followerCount,
    num? friendCount,
  }) =>
      Data(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        shortName: shortName ?? _shortName,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
        email: email ?? _email,
        followerCount: followerCount ?? _followerCount,
        friendCount: friendCount ?? _friendCount,
      );
  num? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get shortName => _shortName;
  String? get fullName => _fullName;
  String? get avatar => _avatar;
  String? get email => _email;
  num? get followerCount => _followerCount;
  num? get friendCount => _friendCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['short_name'] = _shortName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['email'] = _email;
    map['follower_count'] = _followerCount;
    map['friend_count'] = _friendCount;
    return map;
  }
}
