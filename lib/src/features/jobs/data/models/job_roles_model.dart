class JobRolesModel {
  JobRolesModel({
      num? id, 
      String? name, 
      num? topicId, 
      dynamic createdAt, 
      dynamic updatedAt,}){
    _id = id;
    _name = name;
    _topicId = topicId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  JobRolesModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _topicId = json['topic_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _name;
  num? _topicId;
  dynamic _createdAt;
  dynamic _updatedAt;
JobRolesModel copyWith({  num? id,
  String? name,
  num? topicId,
  dynamic createdAt,
  dynamic updatedAt,
}) => JobRolesModel(  id: id ?? _id,
  name: name ?? _name,
  topicId: topicId ?? _topicId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get name => _name;
  num? get topicId => _topicId;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['topic_id'] = _topicId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}