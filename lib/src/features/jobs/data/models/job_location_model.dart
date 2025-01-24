class JobLocationModel {
  JobLocationModel({
    num? provinceId,
    String? provinceName,
    num? districtId,
    String? districtName,
    String? wardId,
    String? wardName,
    String? fullAddress,
    num? latitude,
    num? longitude,
  }) {
    _provinceId = provinceId;
    _provinceName = provinceName;
    _districtId = districtId;
    _districtName = districtName;
    _wardId = wardId;
    _wardName = wardName;
    _fullAddress = fullAddress;
    _latitude = latitude;
    _longitude = longitude;
  }

  JobLocationModel.fromJson(dynamic json) {
    _provinceId = json['province_id'];
    _provinceName = json['province_name'];
    _districtId = json['district_id'];
    _districtName = json['district_name'];
    _wardId = json['ward_id'];
    _wardName = json['ward_name'];
    _fullAddress = json['full_address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }
  num? _provinceId;
  String? _provinceName;
  num? _districtId;
  String? _districtName;
  String? _wardId;
  String? _wardName;
  String? _fullAddress;
  num? _latitude;
  num? _longitude;
  JobLocationModel copyWith({
    num? provinceId,
    String? provinceName,
    num? districtId,
    String? districtName,
    String? wardId,
    String? wardName,
    String? fullAddress,
    num? latitude,
    num? longitude,
  }) =>
      JobLocationModel(
        provinceId: provinceId ?? _provinceId,
        provinceName: provinceName ?? _provinceName,
        districtId: districtId ?? _districtId,
        districtName: districtName ?? _districtName,
        wardId: wardId ?? _wardId,
        wardName: wardName ?? _wardName,
        fullAddress: fullAddress ?? _fullAddress,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
      );
  num? get provinceId => _provinceId;
  String? get provinceName => _provinceName;
  num? get districtId => _districtId;
  String? get districtName => _districtName;
  String? get wardId => _wardId;
  String? get wardName => _wardName;
  String? get fullAddress => _fullAddress;
  num? get latitude => _latitude;
  num? get longitude => _longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province_id'] = _provinceId;
    map['province_name'] = _provinceName;
    map['district_id'] = _districtId;
    map['district_name'] = _districtName;
    map['ward_id'] = _wardId;
    map['ward_name'] = _wardName;
    map['full_address'] = _fullAddress;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }
}
