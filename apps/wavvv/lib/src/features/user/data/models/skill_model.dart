class SkillModel {
  final int id;
  final String name;

  SkillModel({
    required this.id,
    required this.name,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  // Chuyển từ SkillModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Clone SkillModel với các giá trị mới
  SkillModel copyWith({
    int? id,
    String? name,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
