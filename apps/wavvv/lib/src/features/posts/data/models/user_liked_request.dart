class UserLikedRequest {
  UserLikedRequest({
    num? postId,
    num? commentId,
  }) {
    _postId = postId;
    _commentId = commentId;
  }

  UserLikedRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
    _commentId = json['comment_id'];
  }
  num? _postId;
  num? _commentId;
  UserLikedRequest copyWith({
    num? postId,
    num? commentId,
  }) =>
      UserLikedRequest(
        postId: postId ?? _postId,
        commentId: commentId ?? _commentId,
      );
  num? get postId => _postId;
  num? get commentId => _commentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['comment_id'] = _commentId;
    return map;
  }
}
