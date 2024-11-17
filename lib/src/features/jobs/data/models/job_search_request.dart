class JobSearchRequest {
  String? q;
  List<String>? experienceRequired;
  List<String>? jobTopicId;
  List<String>? jobRoleId;
  List<String>? jobType;
  List<String>? province;
  List<String>? employmentType;

  JobSearchRequest({
    this.q,
    this.experienceRequired,
    this.jobTopicId,
    this.jobRoleId,
    this.jobType,
    this.province,
    this.employmentType,
  });

  // Tạo từ JSON
  JobSearchRequest.fromJson(dynamic json) {
    q = json['q'];
    experienceRequired = json['experience_required']?.cast<String>();
    jobTopicId = json['job_topic_id']?.cast<String>();
    jobRoleId = json['job_role_id']?.cast<String>();
    jobType = json['job_type']?.cast<String>();
    province = json['province']?.cast<String>();
    employmentType = json['employment_type']?.cast<String>();
  }

  // Phương thức copyWith để sao chép đối tượng và thay đổi các giá trị nếu cần
  JobSearchRequest copyWith({
    String? q,
    List<String>? experienceRequired,
    List<String>? jobTopicId,
    List<String>? jobRoleId,
    List<String>? jobType,
    List<String>? province,
    List<String>? employmentType,
  }) {
    return JobSearchRequest(
      q: q ?? this.q,
      experienceRequired: experienceRequired ?? this.experienceRequired,
      jobTopicId: jobTopicId ?? this.jobTopicId,
      jobRoleId: jobRoleId ?? this.jobRoleId,
      jobType: jobType ?? this.jobType,
      province: province ?? this.province,
      employmentType: employmentType ?? this.employmentType,
    );
  }

  // Chuyển đối tượng thành Map để sử dụng trong URL query parameters
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (q != null && q!.isNotEmpty) map['q'] = q;

    if (experienceRequired != null) {
      map['experience_required[]'] = experienceRequired;
    }
    if (jobTopicId != null) {
      map['job_topic_id[]'] = jobTopicId;
    }
    if (jobRoleId != null) {
      map['job_role_id[]'] = jobRoleId;
    }
    if (jobType != null) {
      map['job_type[]'] = jobType;
    }
    if (province != null) {
      map['province[]'] = province;
    }
    if (employmentType != null) {
      map['employment_type[]'] = employmentType;
    }

    return map;
  }
}
