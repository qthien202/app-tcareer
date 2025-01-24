class CreateCommentRequest {
  CreateCommentRequest({
    num? postId,
    num? commentId,
    String? content,
    List<String>? mediaUrl,
  }) {
    _postId = postId;
    _commentId = commentId;
    _content = content;
    _mediaUrl = mediaUrl;
  }

  CreateCommentRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
    _commentId = json['comment_id'];
    _content = json['content'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
  }
  num? _postId;
  num? _commentId;
  String? _content;
  List<String>? _mediaUrl;
  CreateCommentRequest copyWith({
    num? postId,
    num? commentId,
    String? content,
    List<String>? mediaUrl,
  }) =>
      CreateCommentRequest(
        postId: postId ?? _postId,
        commentId: commentId ?? _commentId,
        content: content ?? _content,
        mediaUrl: mediaUrl ?? _mediaUrl,
      );
  num? get postId => _postId;
  num? get commentId => _commentId;
  String? get content => _content;
  List<String>? get mediaUrl => _mediaUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['comment_id'] = _commentId;
    map['content'] = _content;
    map['media_url'] = _mediaUrl;
    return map;
  }
}
