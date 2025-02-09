class LikePostData {
  LikePostData({
    Data? data,
    String? message,
  }) {
    _data = data;
    _message = message;
  }

  LikePostData.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  Data? _data;
  String? _message;
  LikePostData copyWith({
    Data? data,
    String? message,
  }) =>
      LikePostData(
        data: data ?? _data,
        message: message ?? _message,
      );
  Data? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

class Data {
  Data({
    num? likeCount,
  }) {
    _likeCount = likeCount;
  }

  Data.fromJson(dynamic json) {
    _likeCount = json['like_count'];
  }
  num? _likeCount;
  Data copyWith({
    num? likeCount,
  }) =>
      Data(
        likeCount: likeCount ?? _likeCount,
      );
  num? get likeCount => _likeCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['like_count'] = _likeCount;
    return map;
  }
}
