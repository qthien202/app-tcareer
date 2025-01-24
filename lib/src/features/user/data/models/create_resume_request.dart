import 'package:app_tcareer/src/features/user/data/models/education_model.dart';
import 'package:app_tcareer/src/features/user/data/models/skill_model.dart';

import 'experience_model.dart';

class CreateResumeRequest {
  CreateResumeRequest({
    List<SkillModel>? skills,
    String? introduction,
    String? careerObjective,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
  }) {
    _skills = skills;
    _introduction = introduction;
    _careerObjective = careerObjective;
    _experience = experience;
    _education = education;
  }

  CreateResumeRequest.fromJson(dynamic json) {
    _skills = json['skills'];
    if (json['skills']) {
      _skills = [];
      json['skills'].forEach((v) {
        _skills?.add(SkillModel.fromJson(v));
      });
    }
    _introduction = json['introduction'];
    _careerObjective = json['career_objective'];
    _experience = json['experience'];
    if (json['education'] != null) {
      _education = [];
      json['education'].forEach((v) {
        _education?.add(EducationModel.fromJson(v));
      });
    }

    if (json['experience'] != null) {
      _experience = [];
      json['experience'].forEach((v) {
        _experience?.add(ExperienceModel.fromJson(v));
      });
    }
    // _education = json['education'];
  }
  List<SkillModel>? _skills;
  String? _introduction;
  String? _careerObjective;
  List<ExperienceModel>? _experience;
  List<EducationModel>? _education;
  CreateResumeRequest copyWith({
    List<SkillModel>? skills,
    String? introduction,
    String? careerObjective,
    List<ExperienceModel>? experience,
    List<EducationModel>? education,
  }) =>
      CreateResumeRequest(
        skills: skills ?? _skills,
        introduction: introduction ?? _introduction,
        careerObjective: careerObjective ?? _careerObjective,
        experience: experience ?? _experience,
        education: education ?? _education,
      );
  List<SkillModel>? get skills => _skills;
  String? get introduction => _introduction;
  String? get careerObjective => _careerObjective;
  List<ExperienceModel>? get experience => _experience;
  List<EducationModel>? get education => _education;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['skills'] = _skills;
    map['introduction'] = _introduction;
    map['career_objective'] = _careerObjective;
    map['experience'] = _experience;
    map['education'] = _education;
    return map;
  }
}
