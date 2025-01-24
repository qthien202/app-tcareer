class RefreshTokenRequest {
  RefreshTokenRequest({
    String? refreshToken,
  }) {
    _refreshToken = refreshToken;
  }

  RefreshTokenRequest.fromJson(dynamic json) {
    _refreshToken = json['refresh_token'];
  }
  String? _refreshToken;

  RefreshTokenRequest copyWith({
    String? refreshToken,
    String? password,
    String? deviceId,
  }) =>
      RefreshTokenRequest(
        refreshToken: refreshToken ?? _refreshToken,
      );
  String? get refreshToken => _refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refresh_token'] = _refreshToken;

    return map;
  }
}
