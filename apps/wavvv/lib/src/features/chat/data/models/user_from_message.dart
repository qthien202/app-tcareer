import 'package:app_tcareer/src/features/chat/data/models/message.dart';

class UserFromMessage {
  UserFromMessage({
    List<Data>? data,
    Response? response,
  }) {
    _data = data;
    _response = response;
  }

  UserFromMessage.fromJson(dynamic json) {
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
  UserFromMessage copyWith({
    List<Data>? data,
    Response? response,
  }) =>
      UserFromMessage(
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
    num? userId,
    String? userFullName,
    String? userAvatar,
    num? conversationId,
    List<MessageModel>? messages,
  }) {
    _userId = userId;
    _userFullName = userFullName;
    _userAvatar = userAvatar;
    _conversationId = conversationId;
    _messages = messages;
  }

  Data.fromJson(dynamic json) {
    _userId = json['user_id'];
    _userFullName = json['user_full_name'];
    _userAvatar = json['user_avatar'];
    _conversationId = json['conversation_id'];
    if (json['messages'] != null) {
      _messages = [];
      json['messages'].forEach((v) {
        _messages?.add(MessageModel.fromJson(v));
      });
    }
  }
  num? _userId;
  String? _userFullName;
  String? _userAvatar;
  num? _conversationId;
  List<MessageModel>? _messages;
  Data copyWith({
    num? userId,
    String? userFullName,
    String? userAvatar,
    num? conversationId,
    List<MessageModel>? messages,
  }) =>
      Data(
        userId: userId ?? _userId,
        userFullName: userFullName ?? _userFullName,
        userAvatar: userAvatar ?? _userAvatar,
        conversationId: conversationId ?? _conversationId,
        messages: messages ?? _messages,
      );
  num? get userId => _userId;
  String? get userFullName => _userFullName;
  String? get userAvatar => _userAvatar;
  num? get conversationId => _conversationId;
  List<MessageModel>? get messages => _messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['user_full_name'] = _userFullName;
    map['user_avatar'] = _userAvatar;
    map['conversation_id'] = _conversationId;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
