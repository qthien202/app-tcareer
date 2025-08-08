class SharePostData {
  SharePostData({
      Data? data, 
      String? message,}){
    _data = data;
    _message = message;
}

  SharePostData.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  Data? _data;
  String? _message;
SharePostData copyWith({  Data? data,
  String? message,
}) => SharePostData(  data: data ?? _data,
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
      num? shareCount,}){
    _shareCount = shareCount;
}

  Data.fromJson(dynamic json) {
    _shareCount = json['share_count'];
  }
  num? _shareCount;
Data copyWith({  num? shareCount,
}) => Data(  shareCount: shareCount ?? _shareCount,
);
  num? get shareCount => _shareCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['share_count'] = _shareCount;
    return map;
  }

}