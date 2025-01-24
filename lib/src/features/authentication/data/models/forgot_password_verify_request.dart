class ForgotPasswordVerifyRequest {
  ForgotPasswordVerifyRequest({
    String? email,
    String? verifyCode,
  }) {
    _email = email;
    _verifyCode = verifyCode;
  }

  ForgotPasswordVerifyRequest.fromJson(dynamic json) {
    _email = json['email'];
    _verifyCode = json['verify_code'];
  }
  String? _email;
  String? _verifyCode;
  ForgotPasswordVerifyRequest copyWith({
    String? email,
    String? verifyCode,
  }) =>
      ForgotPasswordVerifyRequest(
        email: email ?? _email,
        verifyCode: verifyCode ?? _verifyCode,
      );
  String? get email => _email;
  String? get verifyCode => _verifyCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['verify_code'] = _verifyCode;
    return map;
  }
}
