class LoginGoogleRequest {
  LoginGoogleRequest({
      String? accessToken, 
      String? deviceToken, 
      String? deviceId,}){
    _accessToken = accessToken;
    _deviceToken = deviceToken;
    _deviceId = deviceId;
}

  LoginGoogleRequest.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _deviceToken = json['device_token'];
    _deviceId = json['device_id'];
  }
  String? _accessToken;
  String? _deviceToken;
  String? _deviceId;
LoginGoogleRequest copyWith({  String? accessToken,
  String? deviceToken,
  String? deviceId,
}) => LoginGoogleRequest(  accessToken: accessToken ?? _accessToken,
  deviceToken: deviceToken ?? _deviceToken,
  deviceId: deviceId ?? _deviceId,
);
  String? get accessToken => _accessToken;
  String? get deviceToken => _deviceToken;
  String? get deviceId => _deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['device_token'] = _deviceToken;
    map['device_id'] = _deviceId;
    return map;
  }

}