class LikeCommentRequest {
  LikeCommentRequest({
    num? commentId,
  }) {
    _commentId = commentId;
  }

  LikeCommentRequest.fromJson(dynamic json) {
    _commentId = json['comment_id'];
  }
  num? _commentId;
  LikeCommentRequest copyWith({
    num? commentId,
  }) =>
      LikeCommentRequest(
        commentId: commentId ?? _commentId,
      );
  num? get commentId => _commentId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['comment_id'] = _commentId;
    return map;
  }
}
