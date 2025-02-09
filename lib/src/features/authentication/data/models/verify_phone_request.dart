class VerifyPhoneRequest {
  VerifyPhoneRequest({
    String? idToken,
    String? uid,
  }) {
    _idToken = idToken;
    _uid = uid;
  }

  VerifyPhoneRequest.fromJson(dynamic json) {
    _idToken = json['id_token'];
    _uid = json['uid'];
  }
  String? _idToken;
  String? _uid;
  VerifyPhoneRequest copyWith({
    String? idToken,
    String? uid,
  }) =>
      VerifyPhoneRequest(
        idToken: idToken ?? _idToken,
        uid: uid ?? _uid,
      );
  String? get idToken => _idToken;
  String? get uid => _uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_token'] = _idToken;
    map['uid'] = _uid;
    return map;
  }
}
