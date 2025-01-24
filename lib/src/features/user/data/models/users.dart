class Users {
  Users({
      Data? data,}){
    _data = data;
}

  Users.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
Users copyWith({  Data? data,
}) => Users(  data: data ?? _data,
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
      bool? isLoginGoogle, 
      String? firstName, 
      String? lastName, 
      String? shortName, 
      String? fullName, 
      String? phone, 
      String? cvFile, 
      dynamic career, 
      dynamic address, 
      String? avatar, 
      String? email, 
      num? followerCount, 
      num? friendCount, 
      dynamic followed, 
      dynamic friendStatus,}){
    _id = id;
    _isLoginGoogle = isLoginGoogle;
    _firstName = firstName;
    _lastName = lastName;
    _shortName = shortName;
    _fullName = fullName;
    _phone = phone;
    _cvFile = cvFile;
    _career = career;
    _address = address;
    _avatar = avatar;
    _email = email;
    _followerCount = followerCount;
    _friendCount = friendCount;
    _followed = followed;
    _friendStatus = friendStatus;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _isLoginGoogle = json['is_login_google'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _shortName = json['short_name'];
    _fullName = json['full_name'];
    _phone = json['phone'];
    _cvFile = json['cv_file'];
    _career = json['career'];
    _address = json['address'];
    _avatar = json['avatar'];
    _email = json['email'];
    _followerCount = json['follower_count'];
    _friendCount = json['friend_count'];
    _followed = json['followed'];
    _friendStatus = json['friend_status'];
  }
  num? _id;
  bool? _isLoginGoogle;
  String? _firstName;
  String? _lastName;
  String? _shortName;
  String? _fullName;
  String? _phone;
  String? _cvFile;
  dynamic _career;
  dynamic _address;
  String? _avatar;
  String? _email;
  num? _followerCount;
  num? _friendCount;
  dynamic _followed;
  dynamic _friendStatus;
Data copyWith({  num? id,
  bool? isLoginGoogle,
  String? firstName,
  String? lastName,
  String? shortName,
  String? fullName,
  String? phone,
  String? cvFile,
  dynamic career,
  dynamic address,
  String? avatar,
  String? email,
  num? followerCount,
  num? friendCount,
  dynamic followed,
  dynamic friendStatus,
}) => Data(  id: id ?? _id,
  isLoginGoogle: isLoginGoogle ?? _isLoginGoogle,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  shortName: shortName ?? _shortName,
  fullName: fullName ?? _fullName,
  phone: phone ?? _phone,
  cvFile: cvFile ?? _cvFile,
  career: career ?? _career,
  address: address ?? _address,
  avatar: avatar ?? _avatar,
  email: email ?? _email,
  followerCount: followerCount ?? _followerCount,
  friendCount: friendCount ?? _friendCount,
  followed: followed ?? _followed,
  friendStatus: friendStatus ?? _friendStatus,
);
  num? get id => _id;
  bool? get isLoginGoogle => _isLoginGoogle;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get shortName => _shortName;
  String? get fullName => _fullName;
  String? get phone => _phone;
  String? get cvFile => _cvFile;
  dynamic get career => _career;
  dynamic get address => _address;
  String? get avatar => _avatar;
  String? get email => _email;
  num? get followerCount => _followerCount;
  num? get friendCount => _friendCount;
  dynamic get followed => _followed;
  dynamic get friendStatus => _friendStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['is_login_google'] = _isLoginGoogle;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['short_name'] = _shortName;
    map['full_name'] = _fullName;
    map['phone'] = _phone;
    map['cv_file'] = _cvFile;
    map['career'] = _career;
    map['address'] = _address;
    map['avatar'] = _avatar;
    map['email'] = _email;
    map['follower_count'] = _followerCount;
    map['friend_count'] = _friendCount;
    map['followed'] = _followed;
    map['friend_status'] = _friendStatus;
    return map;
  }

}