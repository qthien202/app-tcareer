class JobSearchRequest {
  JobSearchRequest({
    String? q,
    List<num>? jobTopicId,
    List<dynamic>? jobType,
    List<dynamic>? employmentType,
    String? province,
    List<dynamic>? experienceRequired,
  }) {
    _q = q;
    _jobTopicId = jobTopicId;
    _jobType = jobType;
    _employmentType = employmentType;
    _province = province;
    _experienceRequired = experienceRequired;
  }

  JobSearchRequest.fromJson(dynamic json) {
    _q = json['q'];
    _jobTopicId =
        json['job_topic_id'] != null ? json['job_topic_id'].cast<num>() : [];
    if (json['job_type'] != null) {
      _jobType = [];
      json['job_type'].forEach((v) {
        _jobType?.add(v);
      });
    }
    if (json['employment_type'] != null) {
      _employmentType = [];
      json['employment_type'].forEach((v) {
        _employmentType?.add(v);
      });
    }
    _province = json['province'];
    if (json['experience_required'] != null) {
      _experienceRequired = [];
      json['experience_required'].forEach((v) {
        _experienceRequired?.add(v);
      });
    }
  }
  String? _q;
  List<num>? _jobTopicId;
  List<dynamic>? _jobType;
  List<dynamic>? _employmentType;
  String? _province;
  List<dynamic>? _experienceRequired;
  JobSearchRequest copyWith({
    String? q,
    List<num>? jobTopicId,
    List<dynamic>? jobType,
    List<dynamic>? employmentType,
    String? province,
    List<dynamic>? experienceRequired,
  }) =>
      JobSearchRequest(
        q: q ?? _q,
        jobTopicId: jobTopicId ?? _jobTopicId,
        jobType: jobType ?? _jobType,
        employmentType: employmentType ?? _employmentType,
        province: province ?? _province,
        experienceRequired: experienceRequired ?? _experienceRequired,
      );
  String? get q => _q;
  List<num>? get jobTopicId => _jobTopicId;
  List<dynamic>? get jobType => _jobType;
  List<dynamic>? get employmentType => _employmentType;
  String? get province => _province;
  List<dynamic>? get experienceRequired => _experienceRequired;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_q != null && _q!.isNotEmpty) {
      map['q'] = _q;
    }

    if (_jobTopicId != null && _jobTopicId!.isNotEmpty) {
      map['job_topic_id'] = _jobTopicId;
    }

    if (_province != null && _province!.isNotEmpty) {
      map['province'] = _province;
    }

    if (_jobType != null && _jobType!.isNotEmpty) {
      map['job_type'] = _jobType;
    }

    if (_employmentType != null && _employmentType!.isNotEmpty) {
      map['employment_type'] = _employmentType;
    }

    if (_experienceRequired != null && _experienceRequired!.isNotEmpty) {
      map['experience_required'] = _experienceRequired;
    }

    return map;
  }
}
