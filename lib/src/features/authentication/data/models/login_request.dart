class LoginRequest {
  LoginRequest({
    String? email,
    String? phone,
    String? password,
    String? deviceId,
    String? deviceToken,
  }) {
    _phone = phone;
    _email = email;
    _password = password;
    _deviceId = deviceId;
    _deviceToken = deviceToken;
  }

  LoginRequest.fromJson(dynamic json) {
    _phone = json['phone'];
    _email = json['email'];
    _password = json['password'];
    _deviceId = json['device_id'];
    _deviceToken = json['device_token'];
  }
  String? _phone;
  String? _email;
  String? _password;
  String? _deviceId;
  String? _deviceToken;
  LoginRequest copyWith({
    String? phone,
    String? email,
    String? password,
    String? deviceId,
    String? deviceToken,
  }) =>
      LoginRequest(
        phone: phone ?? _phone,
        email: email ?? _email,
        password: password ?? _password,
        deviceId: deviceId ?? _deviceId,
        deviceToken: deviceToken ?? _deviceToken,
      );
  String? get phone => _phone;
  String? get email => _email;
  String? get password => _password;
  String? get deviceId => _deviceId;
  String? get deviceToken => _deviceToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['email'] = _email;
    map['password'] = _password;
    map['device_id'] = _deviceId;
    map['device_token'] = _deviceToken;
    return map;
  }
}
