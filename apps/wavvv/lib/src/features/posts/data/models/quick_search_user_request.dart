class QuickSearchUserRequest {
  QuickSearchUserRequest({
    String? search,
  }) {
    _search = search;
  }

  QuickSearchUserRequest.fromJson(dynamic json) {
    _search = json['search'];
  }
  String? _search;
  QuickSearchUserRequest copyWith({
    String? search,
  }) =>
      QuickSearchUserRequest(
        search: search ?? _search,
      );
  String? get search => _search;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['search'] = _search;
    return map;
  }
}
