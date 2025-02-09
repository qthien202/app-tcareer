class Province {
  Province({
    num? provinceID,
    String? provinceName,
    num? countryID,
    String? code,
    List<String>? nameExtension,
    num? isEnable,
    num? regionID,
    num? regionCPN,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    num? areaID,
    bool? canUpdateCOD,
    num? status,
    String? updatedIP,
    num? updatedEmployee,
    String? updatedSource,
    String? updatedDate,
  }) {
    _provinceID = provinceID;
    _provinceName = provinceName;
    _countryID = countryID;
    _code = code;
    _nameExtension = nameExtension;
    _isEnable = isEnable;
    _regionID = regionID;
    _regionCPN = regionCPN;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _areaID = areaID;
    _canUpdateCOD = canUpdateCOD;
    _status = status;
    _updatedIP = updatedIP;
    _updatedEmployee = updatedEmployee;
    _updatedSource = updatedSource;
    _updatedDate = updatedDate;
  }

  Province.fromJson(dynamic json) {
    _provinceID = json['ProvinceID'];
    _provinceName = json['ProvinceName'];
    _countryID = json['CountryID'];
    _code = json['Code'];
    _nameExtension = json['NameExtension'] != null
        ? json['NameExtension'].cast<String>()
        : [];
    _isEnable = json['IsEnable'];
    _regionID = json['RegionID'];
    _regionCPN = json['RegionCPN'];
    _updatedBy = json['UpdatedBy'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _areaID = json['AreaID'];
    _canUpdateCOD = json['CanUpdateCOD'];
    _status = json['Status'];
    _updatedIP = json['UpdatedIP'];
    _updatedEmployee = json['UpdatedEmployee'];
    _updatedSource = json['UpdatedSource'];
    _updatedDate = json['UpdatedDate'];
  }
  num? _provinceID;
  String? _provinceName;
  num? _countryID;
  String? _code;
  List<String>? _nameExtension;
  num? _isEnable;
  num? _regionID;
  num? _regionCPN;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  num? _areaID;
  bool? _canUpdateCOD;
  num? _status;
  String? _updatedIP;
  num? _updatedEmployee;
  String? _updatedSource;
  String? _updatedDate;
  Province copyWith({
    num? provinceID,
    String? provinceName,
    num? countryID,
    String? code,
    List<String>? nameExtension,
    num? isEnable,
    num? regionID,
    num? regionCPN,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    num? areaID,
    bool? canUpdateCOD,
    num? status,
    String? updatedIP,
    num? updatedEmployee,
    String? updatedSource,
    String? updatedDate,
  }) =>
      Province(
        provinceID: provinceID ?? _provinceID,
        provinceName: provinceName ?? _provinceName,
        countryID: countryID ?? _countryID,
        code: code ?? _code,
        nameExtension: nameExtension ?? _nameExtension,
        isEnable: isEnable ?? _isEnable,
        regionID: regionID ?? _regionID,
        regionCPN: regionCPN ?? _regionCPN,
        updatedBy: updatedBy ?? _updatedBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        areaID: areaID ?? _areaID,
        canUpdateCOD: canUpdateCOD ?? _canUpdateCOD,
        status: status ?? _status,
        updatedIP: updatedIP ?? _updatedIP,
        updatedEmployee: updatedEmployee ?? _updatedEmployee,
        updatedSource: updatedSource ?? _updatedSource,
        updatedDate: updatedDate ?? _updatedDate,
      );
  num? get provinceID => _provinceID;
  String? get provinceName => _provinceName;
  num? get countryID => _countryID;
  String? get code => _code;
  List<String>? get nameExtension => _nameExtension;
  num? get isEnable => _isEnable;
  num? get regionID => _regionID;
  num? get regionCPN => _regionCPN;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get areaID => _areaID;
  bool? get canUpdateCOD => _canUpdateCOD;
  num? get status => _status;
  String? get updatedIP => _updatedIP;
  num? get updatedEmployee => _updatedEmployee;
  String? get updatedSource => _updatedSource;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ProvinceID'] = _provinceID;
    map['ProvinceName'] = _provinceName;
    map['CountryID'] = _countryID;
    map['Code'] = _code;
    map['NameExtension'] = _nameExtension;
    map['IsEnable'] = _isEnable;
    map['RegionID'] = _regionID;
    map['RegionCPN'] = _regionCPN;
    map['UpdatedBy'] = _updatedBy;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['AreaID'] = _areaID;
    map['CanUpdateCOD'] = _canUpdateCOD;
    map['Status'] = _status;
    map['UpdatedIP'] = _updatedIP;
    map['UpdatedEmployee'] = _updatedEmployee;
    map['UpdatedSource'] = _updatedSource;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }
}
