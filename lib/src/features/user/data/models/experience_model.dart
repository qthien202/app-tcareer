class ExperienceModel {
  int? id;
  String? position;
  String? employmentType;
  String? companyName;
  String? startDate;
  String? endDate;
  String? workplaceType;
  String? jobDescription;

  ExperienceModel({
    this.id,
    this.position,
    this.employmentType,
    this.companyName,
    this.startDate,
    this.endDate,
    this.workplaceType,
    this.jobDescription,
  });

  ExperienceModel copyWith({
    int? id,
    String? position,
    String? employmentType,
    String? companyName,
    String? startDate,
    String? endDate,
    String? workplaceType,
    String? jobDescription,
    String? detailedDescription,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      position: position ?? this.position,
      employmentType: employmentType ?? this.employmentType,
      companyName: companyName ?? this.companyName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      workplaceType: workplaceType ?? this.workplaceType,
      jobDescription: jobDescription ?? this.jobDescription,
    );
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'],
      position: json['position'],
      employmentType: json['employmentType'],
      companyName: json['companyName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      workplaceType: json['workplaceType'],
      jobDescription: json['jobDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'employmentType': employmentType,
      'companyName': companyName,
      'startDate': startDate,
      'endDate': endDate,
      'workplaceType': workplaceType,
      'jobDescription': jobDescription,
    };
  }
}
