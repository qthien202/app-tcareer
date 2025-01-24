import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';

class Conversation {
  Conversation({
    UserConversation? conversation,
    Message? message,
  }) {
    _conversation = conversation;
    _message = message;
  }

  Conversation.fromJson(dynamic json) {
    _conversation = json['conversation'] != null
        ? UserConversation.fromJson(json['conversation'])
        : null;
    _message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
  UserConversation? _conversation;
  Message? _message;
  Conversation copyWith({
    UserConversation? conversation,
    Message? message,
  }) =>
      Conversation(
        conversation: conversation ?? _conversation,
        message: message ?? _message,
      );
  UserConversation? get conversation => _conversation;
  Message? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_conversation != null) {
      map['conversation'] = _conversation?.toJson();
    }
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    return map;
  }
}

class Message {
  Message({
    List<MessageModel>? data,
    Response? response,
  }) {
    _data = data;
    _response = response;
  }

  Message.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MessageModel.fromJson(v));
      });
    }
    _response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  List<MessageModel>? _data;
  Response? _response;
  Message copyWith({
    List<MessageModel>? data,
    Response? response,
  }) =>
      Message(
        data: data ?? _data,
        response: response ?? _response,
      );
  List<MessageModel>? get data => _data;
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
