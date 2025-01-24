import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';

class AllConversation {
  AllConversation({
    List<UserConversation>? data,
    Response? response,
  }) {
    _data = data;
    _response = response;
  }

  AllConversation.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(UserConversation.fromJson(v));
      });
    }
    _response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  List<UserConversation>? _data;
  Response? _response;
  AllConversation copyWith({
    List<UserConversation>? data,
    Response? response,
  }) =>
      AllConversation(
        data: data ?? _data,
        response: response ?? _response,
      );
  List<UserConversation>? get data => _data;
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
