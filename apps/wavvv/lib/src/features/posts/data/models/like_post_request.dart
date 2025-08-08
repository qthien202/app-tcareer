class LikePostRequest {
  LikePostRequest({String? postId, int? likeCount}) {
    _postId = postId;
    _likeCount = likeCount;
  }

  LikePostRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
    _likeCount = json['like_count'];
  }
  String? _postId;
  int? _likeCount;

  LikePostRequest copyWith({String? postId, int? likeCount}) => LikePostRequest(
      postId: postId ?? _postId, likeCount: likeCount ?? _likeCount);
  String? get postId => _postId;
  int? get likeCount => _likeCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['like_count'] = _likeCount;

    return map;
  }
}
