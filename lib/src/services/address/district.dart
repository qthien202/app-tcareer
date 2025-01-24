class District {
  District({
    num? districtID,
    num? provinceID,
    String? districtName,
    String? code,
    num? type,
    num? supportType,
    List<String>? nameExtension,
    num? isEnable,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    bool? canUpdateCOD,
    num? status,
    num? pickType,
    num? deliverType,
    WhiteListDistrict? whiteListDistrict,
    String? reasonCode,
    String? reasonMessage,
    dynamic onDates,
    num? updatedEmployee,
    String? updatedDate,
  }) {
    _districtID = districtID;
    _provinceID = provinceID;
    _districtName = districtName;
    _code = code;
    _type = type;
    _supportType = supportType;
    _nameExtension = nameExtension;
    _isEnable = isEnable;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _canUpdateCOD = canUpdateCOD;
    _status = status;
    _pickType = pickType;
    _deliverType = deliverType;

    _reasonCode = reasonCode;
    _reasonMessage = reasonMessage;
    _onDates = onDates;
    _updatedEmployee = updatedEmployee;
    _updatedDate = updatedDate;
  }

  District.fromJson(dynamic json) {
    _districtID = json['DistrictID'];
    _provinceID = json['ProvinceID'];
    _districtName = json['DistrictName'];
    _code = json['Code'];
    _type = json['Type'];
    _supportType = json['SupportType'];
    _nameExtension = json['NameExtension'] != null
        ? json['NameExtension'].cast<String>()
        : [];
    _isEnable = json['IsEnable'];
    _updatedBy = json['UpdatedBy'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _canUpdateCOD = json['CanUpdateCOD'];
    _status = json['Status'];
    _pickType = json['PickType'];
    _deliverType = json['DeliverType'];

    _reasonCode = json['ReasonCode'];
    _reasonMessage = json['ReasonMessage'];
    _onDates = json['OnDates'];
    _updatedEmployee = json['UpdatedEmployee'];
    _updatedDate = json['UpdatedDate'];
  }
  num? _districtID;
  num? _provinceID;
  String? _districtName;
  String? _code;
  num? _type;
  num? _supportType;
  List<String>? _nameExtension;
  num? _isEnable;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  bool? _canUpdateCOD;
  num? _status;
  num? _pickType;
  num? _deliverType;

  String? _reasonCode;
  String? _reasonMessage;
  dynamic _onDates;
  num? _updatedEmployee;
  String? _updatedDate;
  District copyWith({
    num? districtID,
    num? provinceID,
    String? districtName,
    String? code,
    num? type,
    num? supportType,
    List<String>? nameExtension,
    num? isEnable,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    bool? canUpdateCOD,
    num? status,
    num? pickType,
    num? deliverType,
    String? reasonCode,
    String? reasonMessage,
    dynamic onDates,
    num? updatedEmployee,
    String? updatedDate,
  }) =>
      District(
        districtID: districtID ?? _districtID,
        provinceID: provinceID ?? _provinceID,
        districtName: districtName ?? _districtName,
        code: code ?? _code,
        type: type ?? _type,
        supportType: supportType ?? _supportType,
        nameExtension: nameExtension ?? _nameExtension,
        isEnable: isEnable ?? _isEnable,
        updatedBy: updatedBy ?? _updatedBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        canUpdateCOD: canUpdateCOD ?? _canUpdateCOD,
        status: status ?? _status,
        pickType: pickType ?? _pickType,
        deliverType: deliverType ?? _deliverType,
        reasonCode: reasonCode ?? _reasonCode,
        reasonMessage: reasonMessage ?? _reasonMessage,
        onDates: onDates ?? _onDates,
        updatedEmployee: updatedEmployee ?? _updatedEmployee,
        updatedDate: updatedDate ?? _updatedDate,
      );
  num? get districtID => _districtID;
  num? get provinceID => _provinceID;
  String? get districtName => _districtName;
  String? get code => _code;
  num? get type => _type;
  num? get supportType => _supportType;
  List<String>? get nameExtension => _nameExtension;
  num? get isEnable => _isEnable;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  bool? get canUpdateCOD => _canUpdateCOD;
  num? get status => _status;
  num? get pickType => _pickType;
  num? get deliverType => _deliverType;

  String? get reasonCode => _reasonCode;
  String? get reasonMessage => _reasonMessage;
  dynamic get onDates => _onDates;
  num? get updatedEmployee => _updatedEmployee;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistrictID'] = _districtID;
    map['ProvinceID'] = _provinceID;
    map['DistrictName'] = _districtName;
    map['Code'] = _code;
    map['Type'] = _type;
    map['SupportType'] = _supportType;
    map['NameExtension'] = _nameExtension;
    map['IsEnable'] = _isEnable;
    map['UpdatedBy'] = _updatedBy;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['CanUpdateCOD'] = _canUpdateCOD;
    map['Status'] = _status;
    map['PickType'] = _pickType;
    map['DeliverType'] = _deliverType;

    map['ReasonCode'] = _reasonCode;
    map['ReasonMessage'] = _reasonMessage;
    map['OnDates'] = _onDates;
    map['UpdatedEmployee'] = _updatedEmployee;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }
}

class WhiteListDistrict {
  WhiteListDistrict({
    dynamic from,
    dynamic to,
  }) {
    _from = from;
    _to = to;
  }

  WhiteListDistrict.fromJson(dynamic json) {
    _from = json['From'];
    _to = json['To'];
  }
  dynamic _from;
  dynamic _to;
  WhiteListDistrict copyWith({
    dynamic from,
    dynamic to,
  }) =>
      WhiteListDistrict(
        from: from ?? _from,
        to: to ?? _to,
      );
  dynamic get from => _from;
  dynamic get to => _to;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['From'] = _from;
    map['To'] = _to;
    return map;
  }
}
