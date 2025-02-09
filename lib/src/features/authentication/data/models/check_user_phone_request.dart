class CheckUserPhoneRequest {
  CheckUserPhoneRequest({
    String? phone,
  }) {
    _phone = phone;
  }

  CheckUserPhoneRequest.fromJson(dynamic json) {
    _phone = json['phone'];
  }
  String? _phone;
  CheckUserPhoneRequest copyWith({
    String? phone,
  }) =>
      CheckUserPhoneRequest(
        phone: phone ?? _phone,
      );
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    return map;
  }
}
