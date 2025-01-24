class PostRequest {
  PostRequest({String? personal, String? profileUserId, int? page}) {
    _personal = personal;
    _profileUserId = profileUserId;
    _page = page;
  }

  PostRequest.fromJson(dynamic json) {
    _personal = json['personal'];
    _profileUserId = json['profile_user_id'];
    _page = json['page'];
  }
  String? _personal;
  String? _profileUserId;
  int? _page;
  PostRequest copyWith({String? personal, String? profileUserId, int? page}) =>
      PostRequest(
          personal: personal ?? _personal,
          profileUserId: profileUserId ?? _profileUserId,
          page: page ?? _page);
  String? get personal => _personal;
  String? get profileUserId => _profileUserId;
  int? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personal'] = _personal;
    map['profile_user_id'] = _profileUserId;
    map['page'] = _page;
    return map;
  }
}
