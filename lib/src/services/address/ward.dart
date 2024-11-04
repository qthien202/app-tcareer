class Ward {
  Ward({
    String? wardCode,
    num? districtID,
    String? wardName,
    List<String>? nameExtension,
    num? isEnable,
    bool? canUpdateCOD,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    num? supportType,
    num? pickType,
    num? deliverType,
    WhiteListWard? whiteListWard,
    num? status,
    String? reasonCode,
    String? reasonMessage,
    dynamic onDates,
    num? updatedEmployee,
    String? updatedDate,
  }) {
    _wardCode = wardCode;
    _districtID = districtID;
    _wardName = wardName;
    _nameExtension = nameExtension;
    _isEnable = isEnable;
    _canUpdateCOD = canUpdateCOD;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _supportType = supportType;
    _pickType = pickType;
    _deliverType = deliverType;

    _status = status;
    _reasonCode = reasonCode;
    _reasonMessage = reasonMessage;
    _onDates = onDates;
    _updatedEmployee = updatedEmployee;
    _updatedDate = updatedDate;
  }

  Ward.fromJson(dynamic json) {
    _wardCode = json['WardCode'];
    _districtID = json['DistrictID'];
    _wardName = json['WardName'];
    _nameExtension = json['NameExtension'] != null
        ? json['NameExtension'].cast<String>()
        : [];
    _isEnable = json['IsEnable'];
    _canUpdateCOD = json['CanUpdateCOD'];
    _updatedBy = json['UpdatedBy'];
    _createdAt = json['CreatedAt'];
    _updatedAt = json['UpdatedAt'];
    _supportType = json['SupportType'];
    _pickType = json['PickType'];
    _deliverType = json['DeliverType'];

    _status = json['Status'];
    _reasonCode = json['ReasonCode'];
    _reasonMessage = json['ReasonMessage'];
    _onDates = json['OnDates'];
    _updatedEmployee = json['UpdatedEmployee'];
    _updatedDate = json['UpdatedDate'];
  }
  String? _wardCode;
  num? _districtID;
  String? _wardName;
  List<String>? _nameExtension;
  num? _isEnable;
  bool? _canUpdateCOD;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  num? _supportType;
  num? _pickType;
  num? _deliverType;

  num? _status;
  String? _reasonCode;
  String? _reasonMessage;
  dynamic _onDates;
  num? _updatedEmployee;
  String? _updatedDate;
  Ward copyWith({
    String? wardCode,
    num? districtID,
    String? wardName,
    List<String>? nameExtension,
    num? isEnable,
    bool? canUpdateCOD,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    num? supportType,
    num? pickType,
    num? deliverType,
    WhiteListWard? whiteListWard,
    num? status,
    String? reasonCode,
    String? reasonMessage,
    dynamic onDates,
    num? updatedEmployee,
    String? updatedDate,
  }) =>
      Ward(
        wardCode: wardCode ?? _wardCode,
        districtID: districtID ?? _districtID,
        wardName: wardName ?? _wardName,
        nameExtension: nameExtension ?? _nameExtension,
        isEnable: isEnable ?? _isEnable,
        canUpdateCOD: canUpdateCOD ?? _canUpdateCOD,
        updatedBy: updatedBy ?? _updatedBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        supportType: supportType ?? _supportType,
        pickType: pickType ?? _pickType,
        deliverType: deliverType ?? _deliverType,
        status: status ?? _status,
        reasonCode: reasonCode ?? _reasonCode,
        reasonMessage: reasonMessage ?? _reasonMessage,
        onDates: onDates ?? _onDates,
        updatedEmployee: updatedEmployee ?? _updatedEmployee,
        updatedDate: updatedDate ?? _updatedDate,
      );
  String? get wardCode => _wardCode;
  num? get districtID => _districtID;
  String? get wardName => _wardName;
  List<String>? get nameExtension => _nameExtension;
  num? get isEnable => _isEnable;
  bool? get canUpdateCOD => _canUpdateCOD;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get supportType => _supportType;
  num? get pickType => _pickType;
  num? get deliverType => _deliverType;

  num? get status => _status;
  String? get reasonCode => _reasonCode;
  String? get reasonMessage => _reasonMessage;
  dynamic get onDates => _onDates;
  num? get updatedEmployee => _updatedEmployee;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['WardCode'] = _wardCode;
    map['DistrictID'] = _districtID;
    map['WardName'] = _wardName;
    map['NameExtension'] = _nameExtension;
    map['IsEnable'] = _isEnable;
    map['CanUpdateCOD'] = _canUpdateCOD;
    map['UpdatedBy'] = _updatedBy;
    map['CreatedAt'] = _createdAt;
    map['UpdatedAt'] = _updatedAt;
    map['SupportType'] = _supportType;
    map['PickType'] = _pickType;
    map['DeliverType'] = _deliverType;

    map['Status'] = _status;
    map['ReasonCode'] = _reasonCode;
    map['ReasonMessage'] = _reasonMessage;
    map['OnDates'] = _onDates;
    map['UpdatedEmployee'] = _updatedEmployee;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }
}

class WhiteListWard {
  WhiteListWard({
    dynamic from,
    dynamic to,
  }) {
    _from = from;
    _to = to;
  }

  WhiteListWard.fromJson(dynamic json) {
    _from = json['From'];
    _to = json['To'];
  }
  dynamic _from;
  dynamic _to;
  WhiteListWard copyWith({
    dynamic from,
    dynamic to,
  }) =>
      WhiteListWard(
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
