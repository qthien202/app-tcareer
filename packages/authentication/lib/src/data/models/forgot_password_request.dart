class ForgotPasswordRequest {
  ForgotPasswordRequest({
    String? email,
  }) {
    _email = email;
  }

  ForgotPasswordRequest.fromJson(dynamic json) {
    _email = json['email'];
  }
  String? _email;
  ForgotPasswordRequest copyWith({
    String? email,
  }) =>
      ForgotPasswordRequest(
        email: email ?? _email,
      );
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    return map;
  }
}
