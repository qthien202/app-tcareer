class LogoutRequest {
  LogoutRequest({
    String? refreshToken,
  }) {
    _refreshToken = refreshToken;
  }

  LogoutRequest.fromJson(dynamic json) {
    _refreshToken = json['refresh_token'];
  }
  String? _refreshToken;
  LogoutRequest copyWith({
    String? refreshToken,
  }) =>
      LogoutRequest(
        refreshToken: refreshToken ?? _refreshToken,
      );
  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refresh_token'] = _refreshToken;
    return map;
  }
}
