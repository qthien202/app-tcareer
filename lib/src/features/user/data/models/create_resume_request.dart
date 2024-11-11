class CreateResumeRequest {
  CreateResumeRequest({
      String? skills, 
      String? introduction, 
      String? careerObjective, 
      String? experience, 
      String? education,}){
    _skills = skills;
    _introduction = introduction;
    _careerObjective = careerObjective;
    _experience = experience;
    _education = education;
}

  CreateResumeRequest.fromJson(dynamic json) {
    _skills = json['skills'];
    _introduction = json['introduction'];
    _careerObjective = json['career_objective'];
    _experience = json['experience'];
    _education = json['education'];
  }
  String? _skills;
  String? _introduction;
  String? _careerObjective;
  String? _experience;
  String? _education;
CreateResumeRequest copyWith({  String? skills,
  String? introduction,
  String? careerObjective,
  String? experience,
  String? education,
}) => CreateResumeRequest(  skills: skills ?? _skills,
  introduction: introduction ?? _introduction,
  careerObjective: careerObjective ?? _careerObjective,
  experience: experience ?? _experience,
  education: education ?? _education,
);
  String? get skills => _skills;
  String? get introduction => _introduction;
  String? get careerObjective => _careerObjective;
  String? get experience => _experience;
  String? get education => _education;

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