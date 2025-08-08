class ChangePasswordRequest {
  ChangePasswordRequest({
      String? password, 
      String? newPassword, 
      String? passwordNewConfirmation,}){
    _password = password;
    _newPassword = newPassword;
    _passwordNewConfirmation = passwordNewConfirmation;
}

  ChangePasswordRequest.fromJson(dynamic json) {
    _password = json['password'];
    _newPassword = json['new_password'];
    _passwordNewConfirmation = json['password_new_confirmation'];
  }
  String? _password;
  String? _newPassword;
  String? _passwordNewConfirmation;
ChangePasswordRequest copyWith({  String? password,
  String? newPassword,
  String? passwordNewConfirmation,
}) => ChangePasswordRequest(  password: password ?? _password,
  newPassword: newPassword ?? _newPassword,
  passwordNewConfirmation: passwordNewConfirmation ?? _passwordNewConfirmation,
);
  String? get password => _password;
  String? get newPassword => _newPassword;
  String? get passwordNewConfirmation => _passwordNewConfirmation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['password'] = _password;
    map['new_password'] = _newPassword;
    map['password_new_confirmation'] = _passwordNewConfirmation;
    return map;
  }

}