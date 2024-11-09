class JobModel {
  JobModel({
      String? title, 
      num? jobTopicId, 
      String? jobTopicName, 
      num? jobRoleId, 
      String? jobRoleName, 
      String? jobType, 
      String? jobDescription, 
      dynamic detailLocation, 
      num? latitude, 
      num? longitude, 
      String? employmentType, 
      String? experienceName, 
      String? ctyName, 
      String? ctyImageUrl, 
      num? experienceRequired, 
      num? positionsAvailable,}){
    _title = title;
    _jobTopicId = jobTopicId;
    _jobTopicName = jobTopicName;
    _jobRoleId = jobRoleId;
    _jobRoleName = jobRoleName;
    _jobType = jobType;
    _jobDescription = jobDescription;
    _detailLocation = detailLocation;
    _latitude = latitude;
    _longitude = longitude;
    _employmentType = employmentType;
    _experienceName = experienceName;
    _ctyName = ctyName;
    _ctyImageUrl = ctyImageUrl;
    _experienceRequired = experienceRequired;
    _positionsAvailable = positionsAvailable;
}

  JobModel.fromJson(dynamic json) {
    _title = json['title'];
    _jobTopicId = json['job_topic_id'];
    _jobTopicName = json['job_topic_name'];
    _jobRoleId = json['job_role_id'];
    _jobRoleName = json['job_role_name'];
    _jobType = json['job_type'];
    _jobDescription = json['job_description'];
    _detailLocation = json['detail_location'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _employmentType = json['employment_type'];
    _experienceName = json['experience_name'];
    _ctyName = json['cty_name'];
    _ctyImageUrl = json['cty_image_url'];
    _experienceRequired = json['experience_required'];
    _positionsAvailable = json['positions_available'];
  }
  String? _title;
  num? _jobTopicId;
  String? _jobTopicName;
  num? _jobRoleId;
  String? _jobRoleName;
  String? _jobType;
  String? _jobDescription;
  dynamic _detailLocation;
  num? _latitude;
  num? _longitude;
  String? _employmentType;
  String? _experienceName;
  String? _ctyName;
  String? _ctyImageUrl;
  num? _experienceRequired;
  num? _positionsAvailable;
JobModel copyWith({  String? title,
  num? jobTopicId,
  String? jobTopicName,
  num? jobRoleId,
  String? jobRoleName,
  String? jobType,
  String? jobDescription,
  dynamic detailLocation,
  num? latitude,
  num? longitude,
  String? employmentType,
  String? experienceName,
  String? ctyName,
  String? ctyImageUrl,
  num? experienceRequired,
  num? positionsAvailable,
}) => JobModel(  title: title ?? _title,
  jobTopicId: jobTopicId ?? _jobTopicId,
  jobTopicName: jobTopicName ?? _jobTopicName,
  jobRoleId: jobRoleId ?? _jobRoleId,
  jobRoleName: jobRoleName ?? _jobRoleName,
  jobType: jobType ?? _jobType,
  jobDescription: jobDescription ?? _jobDescription,
  detailLocation: detailLocation ?? _detailLocation,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  employmentType: employmentType ?? _employmentType,
  experienceName: experienceName ?? _experienceName,
  ctyName: ctyName ?? _ctyName,
  ctyImageUrl: ctyImageUrl ?? _ctyImageUrl,
  experienceRequired: experienceRequired ?? _experienceRequired,
  positionsAvailable: positionsAvailable ?? _positionsAvailable,
);
  String? get title => _title;
  num? get jobTopicId => _jobTopicId;
  String? get jobTopicName => _jobTopicName;
  num? get jobRoleId => _jobRoleId;
  String? get jobRoleName => _jobRoleName;
  String? get jobType => _jobType;
  String? get jobDescription => _jobDescription;
  dynamic get detailLocation => _detailLocation;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get employmentType => _employmentType;
  String? get experienceName => _experienceName;
  String? get ctyName => _ctyName;
  String? get ctyImageUrl => _ctyImageUrl;
  num? get experienceRequired => _experienceRequired;
  num? get positionsAvailable => _positionsAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['job_topic_id'] = _jobTopicId;
    map['job_topic_name'] = _jobTopicName;
    map['job_role_id'] = _jobRoleId;
    map['job_role_name'] = _jobRoleName;
    map['job_type'] = _jobType;
    map['job_description'] = _jobDescription;
    map['detail_location'] = _detailLocation;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['employment_type'] = _employmentType;
    map['experience_name'] = _experienceName;
    map['cty_name'] = _ctyName;
    map['cty_image_url'] = _ctyImageUrl;
    map['experience_required'] = _experienceRequired;
    map['positions_available'] = _positionsAvailable;
    return map;
  }

}