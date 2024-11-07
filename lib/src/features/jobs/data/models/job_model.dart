class JobModel {
  JobModel({
      String? title, 
      num? jobTopicId, 
      String? jobType, 
      JobDescription? jobDescription, 
      String? selfDescription, 
      String? detailLocation, 
      num? latitude, 
      num? longitude, 
      String? province, 
      String? employmentType,}){
    _title = title;
    _jobTopicId = jobTopicId;
    _jobType = jobType;
    _jobDescription = jobDescription;
    _selfDescription = selfDescription;
    _detailLocation = detailLocation;
    _latitude = latitude;
    _longitude = longitude;
    _province = province;
    _employmentType = employmentType;
}

  JobModel.fromJson(dynamic json) {
    _title = json['title'];
    _jobTopicId = json['job_topic_id'];
    _jobType = json['job_type'];
    _jobDescription = json['job_description'] != null ? JobDescription.fromJson(json['job_description']) : null;
    _selfDescription = json['self_description'];
    _detailLocation = json['detail_location'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _province = json['province'];
    _employmentType = json['employment_type'];
  }
  String? _title;
  num? _jobTopicId;
  String? _jobType;
  JobDescription? _jobDescription;
  String? _selfDescription;
  String? _detailLocation;
  num? _latitude;
  num? _longitude;
  String? _province;
  String? _employmentType;
JobModel copyWith({  String? title,
  num? jobTopicId,
  String? jobType,
  JobDescription? jobDescription,
  String? selfDescription,
  String? detailLocation,
  num? latitude,
  num? longitude,
  String? province,
  String? employmentType,
}) => JobModel(  title: title ?? _title,
  jobTopicId: jobTopicId ?? _jobTopicId,
  jobType: jobType ?? _jobType,
  jobDescription: jobDescription ?? _jobDescription,
  selfDescription: selfDescription ?? _selfDescription,
  detailLocation: detailLocation ?? _detailLocation,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  province: province ?? _province,
  employmentType: employmentType ?? _employmentType,
);
  String? get title => _title;
  num? get jobTopicId => _jobTopicId;
  String? get jobType => _jobType;
  JobDescription? get jobDescription => _jobDescription;
  String? get selfDescription => _selfDescription;
  String? get detailLocation => _detailLocation;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get province => _province;
  String? get employmentType => _employmentType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['job_topic_id'] = _jobTopicId;
    map['job_type'] = _jobType;
    if (_jobDescription != null) {
      map['job_description'] = _jobDescription?.toJson();
    }
    map['self_description'] = _selfDescription;
    map['detail_location'] = _detailLocation;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['province'] = _province;
    map['employment_type'] = _employmentType;
    return map;
  }

}

class JobDescription {
  JobDescription({
      String? mtcngvic, 
      String? yucungtuyn, 
      String? quynli,}){
    _mtcngvic = mtcngvic;
    _yucungtuyn = yucungtuyn;
    _quynli = quynli;
}

  JobDescription.fromJson(dynamic json) {
    _mtcngvic = json['Mô tả công việc'];
    _yucungtuyn = json['Yêu cầu ứng tuyển'];
    _quynli = json['Quyền lợi'];
  }
  String? _mtcngvic;
  String? _yucungtuyn;
  String? _quynli;
JobDescription copyWith({  String? mtcngvic,
  String? yucungtuyn,
  String? quynli,
}) => JobDescription(  mtcngvic: mtcngvic ?? _mtcngvic,
  yucungtuyn: yucungtuyn ?? _yucungtuyn,
  quynli: quynli ?? _quynli,
);
  String? get mtcngvic => _mtcngvic;
  String? get yucungtuyn => _yucungtuyn;
  String? get quynli => _quynli;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Mô tả công việc'] = _mtcngvic;
    map['Yêu cầu ứng tuyển'] = _yucungtuyn;
    map['Quyền lợi'] = _quynli;
    return map;
  }

}