class Users {
  Users({
    Data? data,
  }) {
    _data = data;
  }

  Users.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
  Users copyWith({
    Data? data,
  }) =>
      Users(
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
    String? firstName,
    String? lastName,
    String? shortName,
    String? fullName,
    String? avatar,
    String? email,
    String? phone,
    num? followerCount,
    num? friendCount,
    bool? followed,
    String? friendStatus,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _shortName = shortName;
    _fullName = fullName;
    _avatar = avatar;
    _email = email;
    _phone = phone;
    _followerCount = followerCount;
    _friendCount = friendCount;
    _followed = followed;
    _friendStatus = friendStatus;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _shortName = json['short_name'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
    _email = json['email'];
    _phone = json['phone'];
    _followerCount = json['follower_count'];
    _friendCount = json['friend_count'];
    _followed = json['followed'];
    _friendStatus = json['friend_status'];
  }
  num? _id;
  String? _firstName;
  String? _lastName;
  String? _shortName;
  String? _fullName;
  String? _avatar;
  String? _email;
  String? _phone;
  num? _followerCount;
  num? _friendCount;
  bool? _followed;
  String? _friendStatus;
  Data copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? shortName,
    String? fullName,
    String? avatar,
    String? phone,
    String? email,
    num? followerCount,
    num? friendCount,
    bool? followed,
    String? friendStatus,
  }) =>
      Data(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        shortName: shortName ?? _shortName,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
        email: email ?? _email,
        phone: phone ?? _phone,
        followerCount: followerCount ?? _followerCount,
        friendCount: friendCount ?? _friendCount,
        followed: followed ?? _followed,
        friendStatus: friendStatus ?? _friendStatus,
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
  bool? get followed => _followed;
  String? get friendStatus => _friendStatus;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['short_name'] = _shortName;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    map['email'] = _email;
    map['phone'] = _phone;
    map['follower_count'] = _followerCount;
    map['friend_count'] = _friendCount;
    map['followed'] = _followed;
    map['friend_status'] = _friendStatus;
    return map;
  }
}
