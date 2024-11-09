class JobTopicModel {
  JobTopicModel({
      num? id, 
      String? topicName, 
      dynamic topicNameEn, 
      String? createdAt, 
      String? updatedAt, 
      dynamic deletedAt,}){
    _id = id;
    _topicName = topicName;
    _topicNameEn = topicNameEn;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  JobTopicModel.fromJson(dynamic json) {
    _id = json['id'];
    _topicName = json['topic_name'];
    _topicNameEn = json['topic_name_en'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  num? _id;
  String? _topicName;
  dynamic _topicNameEn;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
JobTopicModel copyWith({  num? id,
  String? topicName,
  dynamic topicNameEn,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
}) => JobTopicModel(  id: id ?? _id,
  topicName: topicName ?? _topicName,
  topicNameEn: topicNameEn ?? _topicNameEn,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
);
  num? get id => _id;
  String? get topicName => _topicName;
  dynamic get topicNameEn => _topicNameEn;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['topic_name'] = _topicName;
    map['topic_name_en'] = _topicNameEn;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }

}