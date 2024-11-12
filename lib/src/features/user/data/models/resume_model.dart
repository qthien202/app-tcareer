import 'package:app_tcareer/src/features/user/data/models/experience_model.dart';

import 'education_model.dart';

class ResumeModel {
  ResumeModel({
    Data? data,
  }) {
    _data = data;
  }

  ResumeModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
  ResumeModel copyWith({
    Data? data,
  }) =>
      ResumeModel(
        data: data ?? _data,
      );
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    num? id,
    num? userId,
    String? introduction,
    dynamic skills,
    dynamic careerObjective,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _introduction = introduction;
    _skills = skills;
    _careerObjective = careerObjective;
    _experience = experience;
    _education = education;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _introduction = json['introduction'];
    _skills = json['skills'];
    _careerObjective = json['career_objective'];
    if (json['experience'] != null) {
      _experience = [];
      json['experience'].forEach((v) {
        _experience?.add(ExperienceModel.fromJson(v));
      });
    }
    if (json['education'] != null) {
      _education = [];
      json['education'].forEach((v) {
        _education?.add(EducationModel.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _userId;
  String? _introduction;
  dynamic _skills;
  dynamic _careerObjective;
  List<ExperienceModel>? _experience;
  List<EducationModel>? _education;
  String? _createdAt;
  String? _updatedAt;
  Data copyWith({
    num? id,
    num? userId,
    String? introduction,
    dynamic skills,
    dynamic careerObjective,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        userId: userId ?? _userId,
        introduction: introduction ?? _introduction,
        skills: skills ?? _skills,
        careerObjective: careerObjective ?? _careerObjective,
        experience: experience ?? _experience,
        education: education ?? _education,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get userId => _userId;
  String? get introduction => _introduction;
  dynamic get skills => _skills;
  dynamic get careerObjective => _careerObjective;
  List<ExperienceModel>? get experience => _experience;
  List<EducationModel>? get education => _education;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['introduction'] = _introduction;
    map['skills'] = _skills;
    map['career_objective'] = _careerObjective;
    map['experience'] = _experience;
    map['education'] = _education;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
