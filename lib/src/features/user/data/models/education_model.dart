class EducationModel {
  EducationModel({
    int? id, // Thêm id
    String? school,
    String? major,
    String? startDate,
    String? endDate,
  }) {
    _id = id;
    _school = school;
    _major = major;
    _startDate = startDate;
    _endDate = endDate;
  }

  EducationModel.fromJson(dynamic json) {
    _id = json['id']; // Thêm id vào fromJson
    _school = json['school'];
    _major = json['major'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
  }

  int? _id; // Thêm id
  String? _school;
  String? _major;
  String? _startDate;
  String? _endDate;

  // Cập nhật copyWith để hỗ trợ id
  EducationModel copyWith({
    int? id,
    String? school,
    String? major,
    String? startDate,
    String? endDate,
  }) =>
      EducationModel(
        id: id ?? _id,
        school: school ?? _school,
        major: major ?? _major,
        startDate: startDate ?? _startDate,
        endDate: endDate ?? _endDate,
      );

  int? get id => _id; // Getter cho id
  String? get school => _school;
  String? get major => _major;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id; // Thêm id vào toJson
    map['school'] = _school;
    map['major'] = _major;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    return map;
  }
}
