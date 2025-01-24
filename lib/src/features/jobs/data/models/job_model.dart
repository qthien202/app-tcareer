import 'package:app_tcareer/src/features/jobs/data/models/job_location_model.dart';

class JobModel {
  JobModel(
      {num? id,
      num? userId,
      String? userName,
      String? title,
      bool? isApplied,
      bool? isFavorite,
      bool? employerSeen,
      String? employerSeenAt,
      String? appliedAt,
      num? jobTopicId,
      String? province,
      String? jobTopicName,
      num? jobRoleId,
      String? jobRoleName,
      String? jobType,
      String? jobDescription,
      JobLocationModel? detailLocation,
      num? latitude,
      num? longitude,
      String? employmentType,
      String? experienceName,
      String? ctyName,
      String? ctyImageUrl,
      num? experienceRequired,
      num? positionsAvailable,
      String? updatedAt,
      String? expiredDate}) {
    _id = id;
    _userId = userId;
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
    _updatedAt = updatedAt;
    _expiredDate = expiredDate;
    _isApplied = isApplied;
    _isFavorite = isFavorite;
    _province = province;
  }

  bool isValid() {
    return _title != null &&
        _jobTopicId != null &&
        _jobTopicName != null &&
        _jobRoleId != null &&
        _jobRoleName != null &&
        _jobType != null &&
        _jobDescription != null &&
        _detailLocation != null &&
        _latitude != null &&
        _longitude != null &&
        _employmentType != null &&
        _experienceName != null &&
        _ctyName != null &&
        _ctyImageUrl != null &&
        _experienceRequired != null &&
        _positionsAvailable != null &&
        _expiredDate != null &&
        province != null;
  }

  void reset() {
    _title = null;
    _jobTopicId = null;
    _jobTopicName = null;
    _jobRoleId = null;
    _jobRoleName = null;
    _jobType = null;
    _jobDescription = null;
    _detailLocation = null;
    _latitude = null;
    _longitude = null;
    _employmentType = null;
    _experienceName = null;
    _ctyName = null;
    _ctyImageUrl = null;
    _experienceRequired = null;
    _positionsAvailable = null;
    _updatedAt = null;
    _expiredDate = null;
    _province = null;
  }

  JobModel.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _userName = json['user_name'];
    _title = json['title'];
    _isApplied = json['is_applied'];
    _isFavorite = json['is_favorite'];
    _employerSeen = json['employer_seen'];
    _employerSeenAt = json['employer_seen_at'];
    _appliedAt = json['applied_at'];
    _jobTopicId = json['job_topic_id'];
    _jobTopicName = json['job_topic_name'];
    _jobRoleId = json['job_role_id'];
    _jobRoleName = json['job_role_name'];
    _jobType = json['job_type'];
    _jobDescription = json['job_description'];
    _detailLocation = JobLocationModel.fromJson(json['detail_location']);
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _employmentType = json['employment_type'];
    _experienceName = json['experience_name'];
    _ctyName = json['cty_name'];
    _ctyImageUrl = json['cty_image_url'];
    _experienceRequired = json['experience_required'];
    _positionsAvailable = json['positions_available'];
    _updatedAt = json['updated_at'];
    _expiredDate = json['expired_date'];
    _province = json['province'];
  }
  num? _id;
  num? _userId;
  String? _userName;
  String? _title;
  bool? _isApplied;
  bool? _isFavorite;
  bool? _employerSeen;
  String? _employerSeenAt;
  String? _appliedAt;
  num? _jobTopicId;
  String? _jobTopicName;
  num? _jobRoleId;
  String? _jobRoleName;
  String? _jobType;
  String? _jobDescription;
  JobLocationModel? _detailLocation;
  num? _latitude;
  num? _longitude;
  String? _employmentType;
  String? _experienceName;
  String? _ctyName;
  String? _ctyImageUrl;
  num? _experienceRequired;
  num? _positionsAvailable;
  String? _updatedAt;
  String? _expiredDate;
  String? _province;
  JobModel copyWith({
    num? id,
    num? userId,
    String? userName,
    String? title,
    bool? isApplied,
    bool? isFavorite,
    bool? employerSeen,
    String? employerSeenAt,
    String? appliedAt,
    num? jobTopicId,
    String? jobTopicName,
    num? jobRoleId,
    String? jobRoleName,
    String? jobType,
    String? jobDescription,
    JobLocationModel? detailLocation,
    num? latitude,
    num? longitude,
    String? employmentType,
    String? experienceName,
    String? ctyName,
    String? ctyImageUrl,
    num? experienceRequired,
    num? positionsAvailable,
    String? updatedAt,
    String? expiredDate,
    String? province,
  }) =>
      JobModel(
          userId: userId ?? _userId,
          userName: userName ?? _userName,
          id: id ?? _id,
          title: title ?? _title,
          isApplied: isApplied ?? _isApplied,
          isFavorite: isFavorite ?? _isFavorite,
          employerSeen: employerSeen ?? _employerSeen,
          employerSeenAt: employerSeenAt ?? _employerSeenAt,
          appliedAt: appliedAt ?? _appliedAt,
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
          updatedAt: updatedAt ?? _updatedAt,
          expiredDate: expiredDate ?? _expiredDate,
          province: province ?? _province);
  num? get id => _id;
  num? get userId => _userId;
  String? get userName => _userName;
  String? get title => _title;
  bool? get isApplied => _isApplied;
  bool? get isFavorite => _isFavorite;
  bool? get employerSeen => _employerSeen;
  String? get employerSeenAt => _employerSeenAt;
  String? get appliedAt => _appliedAt;
  num? get jobTopicId => _jobTopicId;
  String? get jobTopicName => _jobTopicName;
  num? get jobRoleId => _jobRoleId;
  String? get jobRoleName => _jobRoleName;
  String? get jobType => _jobType;
  String? get jobDescription => _jobDescription;
  JobLocationModel? get detailLocation => _detailLocation;
  num? get latitude => _latitude;
  num? get longitude => _longitude;
  String? get employmentType => _employmentType;
  String? get experienceName => _experienceName;
  String? get ctyName => _ctyName;
  String? get ctyImageUrl => _ctyImageUrl;
  num? get experienceRequired => _experienceRequired;
  num? get positionsAvailable => _positionsAvailable;
  String? get updatedAt => _updatedAt;
  String? get expiredDate => _expiredDate;
  String? get province => _province;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['user_name'] = _userName;
    map['title'] = _title;
    map['is_applied'] = _isApplied;
    map['is_favorite'] = _isFavorite;
    map['employer_seen'] = _employerSeen;
    map['employer_seen_at'] = _employerSeenAt;
    map['applied_at'] = _appliedAt;
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
    map['updated_at'] = _updatedAt;
    map['expired_date'] = _expiredDate;
    map['province'] = _province;
    return map;
  }
}
