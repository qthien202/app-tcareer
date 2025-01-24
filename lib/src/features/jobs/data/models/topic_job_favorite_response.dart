class TopicJobFavoriteResponse {
  TopicJobFavoriteResponse({
      List<Data>? data, 
      Response? response,}){
    _data = data;
    _response = response;
}

  TopicJobFavoriteResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  List<Data>? _data;
  Response? _response;
TopicJobFavoriteResponse copyWith({  List<Data>? data,
  Response? response,
}) => TopicJobFavoriteResponse(  data: data ?? _data,
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
      num? count,}){
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
Response copyWith({  String? status,
  num? code,
  num? count,
}) => Response(  status: status ?? _status,
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
      num? topicId, 
      String? topicName,}){
    _id = id;
    _topicId = topicId;
    _topicName = topicName;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _topicId = json['topic_id'];
    _topicName = json['topic_name'];
  }
  num? _id;
  num? _topicId;
  String? _topicName;
Data copyWith({  num? id,
  num? topicId,
  String? topicName,
}) => Data(  id: id ?? _id,
  topicId: topicId ?? _topicId,
  topicName: topicName ?? _topicName,
);
  num? get id => _id;
  num? get topicId => _topicId;
  String? get topicName => _topicName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['topic_id'] = _topicId;
    map['topic_name'] = _topicName;
    return map;
  }

}