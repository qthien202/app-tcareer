class QuickSearchUserData {
  QuickSearchUserData({
    List<Data>? data,
    Response? response,
  }) {
    _data = data;
    _response = response;
  }

  QuickSearchUserData.fromJson(dynamic json) {
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
  QuickSearchUserData copyWith({
    List<Data>? data,
    Response? response,
  }) =>
      QuickSearchUserData(
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
    String? fullName,
    String? avatar,
  }) {
    _id = id;
    _fullName = fullName;
    _avatar = avatar;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fullName = json['full_name'];
    _avatar = json['avatar'];
  }
  num? _id;
  String? _fullName;
  String? _avatar;
  Data copyWith({
    num? id,
    String? fullName,
    String? avatar,
  }) =>
      Data(
        id: id ?? _id,
        fullName: fullName ?? _fullName,
        avatar: avatar ?? _avatar,
      );
  num? get id => _id;
  String? get fullName => _fullName;
  String? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['full_name'] = _fullName;
    map['avatar'] = _avatar;
    return map;
  }
}
