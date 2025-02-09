class ResetPasswordRequest {
  ResetPasswordRequest({
    String? email,
    String? phone,
    String? password,
    String? key,
  }) {
    _email = email;
    _phone = phone;
    _password = password;
    _key = key;
  }

  ResetPasswordRequest.fromJson(dynamic json) {
    _email = json['email'];
    _phone = json['phone'];
    _password = json['password'];
    _key = json['key'];
  }
  String? _email;
  String? _phone;
  String? _password;
  String? _key;
  ResetPasswordRequest copyWith({
    String? email,
    String? phone,
    String? password,
    String? key,
  }) =>
      ResetPasswordRequest(
        email: email ?? _email,
        phone: phone ?? _phone,
        password: password ?? _password,
        key: key ?? _key,
      );
  String? get email => _email;
  String? get phone => _phone;
  String? get password => _password;
  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['phone'] = _phone;
    map['password'] = _password;
    map['key'] = _key;
    return map;
  }
}
