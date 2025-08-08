class CreatePostRequest {
  CreatePostRequest({
    String? body,
    String? privacy,
    List<String>? mediaUrl,
  }) {
    _body = body;
    _privacy = privacy;
    _mediaUrl = mediaUrl;
  }

  CreatePostRequest.fromJson(dynamic json) {
    _body = json['body'];
    _privacy = json['privacy'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
  }
  String? _body;
  String? _privacy;
  List<String>? _mediaUrl;
  CreatePostRequest copyWith({
    String? body,
    String? privacy,
    List<String>? mediaUrl,
  }) =>
      CreatePostRequest(
        body: body ?? _body,
        privacy: privacy ?? _privacy,
        mediaUrl: mediaUrl ?? _mediaUrl,
      );
  String? get body => _body;
  String? get privacy => _privacy;
  List<String>? get mediaUrl => _mediaUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['body'] = _body;
    map['privacy'] = _privacy;
    map['media_url'] = _mediaUrl;
    return map;
  }
}
