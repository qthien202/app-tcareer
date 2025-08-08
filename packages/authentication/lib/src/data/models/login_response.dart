class LoginResponse {
  LoginResponse({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    num? expiresIn,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenType = tokenType;
    _expiresIn = expiresIn;
  }

  LoginResponse.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _refreshToken = json['refresh_token'];
    _tokenType = json['token_type'];
    _expiresIn = json['expires_in'];
  }
  String? _accessToken;
  String? _refreshToken;
  String? _tokenType;
  num? _expiresIn;
  LoginResponse copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    num? expiresIn,
  }) =>
      LoginResponse(
        accessToken: accessToken ?? _accessToken,
        refreshToken: refreshToken ?? _refreshToken,
        tokenType: tokenType ?? _tokenType,
        expiresIn: expiresIn ?? _expiresIn,
      );
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get tokenType => _tokenType;
  num? get expiresIn => _expiresIn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['refresh_token'] = _refreshToken;
    map['token_type'] = _tokenType;
    map['expires_in'] = _expiresIn;
    return map;
  }
}
