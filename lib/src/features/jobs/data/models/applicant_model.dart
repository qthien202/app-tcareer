class ApplicantModel {
  ApplicantModel({
    num? id,
    num? jobId,
    num? userId,
    String? avatar,
    String? fullName,
    String? email,
    dynamic career,
    String? phone,
    String? cvFile,
    dynamic note,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _jobId = jobId;
    _userId = userId;
    _avatar = avatar;
    _fullName = fullName;
    _email = email;
    _career = career;
    _phone = phone;
    _cvFile = cvFile;
    _note = note;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  ApplicantModel.fromJson(dynamic json) {
    _id = json['id'];
    _jobId = json['job_id'];
    _userId = json['user_id'];
    _avatar = json['avatar'];
    _fullName = json['full_name'];
    _email = json['email'];
    _career = json['career'];
    _phone = json['phone'];
    _cvFile = json['cv_file'];
    _note = json['note'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _jobId;
  num? _userId;
  String? _avatar;
  String? _fullName;
  String? _email;
  dynamic _career;
  String? _phone;
  String? _cvFile;
  dynamic _note;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  ApplicantModel copyWith({
    num? id,
    num? jobId,
    num? userId,
    String? avatar,
    String? fullName,
    String? email,
    dynamic career,
    String? phone,
    String? cvFile,
    dynamic note,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) =>
      ApplicantModel(
        id: id ?? _id,
        jobId: jobId ?? _jobId,
        userId: userId ?? _userId,
        avatar: avatar ?? _avatar,
        fullName: fullName ?? _fullName,
        email: email ?? _email,
        career: career ?? _career,
        phone: phone ?? _phone,
        cvFile: cvFile ?? _cvFile,
        note: note ?? _note,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get jobId => _jobId;
  num? get userId => _userId;
  String? get avatar => _avatar;
  String? get fullName => _fullName;
  String? get email => _email;
  dynamic get career => _career;
  String? get phone => _phone;
  String? get cvFile => _cvFile;
  dynamic get note => _note;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['job_id'] = _jobId;
    map['user_id'] = _userId;
    map['avatar'] = _avatar;
    map['full_name'] = _fullName;
    map['email'] = _email;
    map['career'] = _career;
    map['phone'] = _phone;
    map['cv_file'] = _cvFile;
    map['note'] = _note;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
