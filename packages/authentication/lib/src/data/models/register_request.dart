class RegisterRequest {
  RegisterRequest({
    String? phone,
    String? name,
    String? email,
    String? password,
  }) {
    _phone = phone;
    _name = name;
    _email = email;
    _password = password;
  }

  RegisterRequest.fromJson(dynamic json) {
    _phone = json['phone'];
    _name = json['name'];
    _email = json['email'];
    _password = json['password'];
  }
  String? _phone;
  String? _name;
  String? _email;
  String? _password;
  RegisterRequest copyWith({
    String? phone,
    String? name,
    String? email,
    String? password,
  }) =>
      RegisterRequest(
        phone: phone ?? _phone,
        name: name ?? _name,
        email: email ?? _email,
        password: password ?? _password,
      );
  String? get phone => _phone;
  String? get name => _name;
  String? get email => _email;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }
}
