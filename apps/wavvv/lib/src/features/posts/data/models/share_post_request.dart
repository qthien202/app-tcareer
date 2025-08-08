class SharePostRequest {
  SharePostRequest({
    num? postId,
    String? body,
    String? privacy,
  }) {
    _postId = postId;
    _body = body;
    _privacy = privacy;
  }

  SharePostRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
    _body = json['body'];
    _privacy = json['privacy'];
  }
  num? _postId;
  String? _body;
  String? _privacy;
  SharePostRequest copyWith({
    num? postId,
    String? body,
    String? privacy,
  }) =>
      SharePostRequest(
        postId: postId ?? _postId,
        body: body ?? _body,
        privacy: privacy ?? _privacy,
      );
  num? get postId => _postId;
  String? get body => _body;
  String? get privacy => _privacy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['body'] = _body;
    map['privacy'] = _privacy;
    return map;
  }
}
