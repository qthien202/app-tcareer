class AddJobTopicRequest {
  AddJobTopicRequest({
      List<num>? topicIds,}){
    _topicIds = topicIds;
}

  AddJobTopicRequest.fromJson(dynamic json) {
    _topicIds = json['topic_ids'] != null ? json['topic_ids'].cast<num>() : [];
  }
  List<num>? _topicIds;
AddJobTopicRequest copyWith({  List<num>? topicIds,
}) => AddJobTopicRequest(  topicIds: topicIds ?? _topicIds,
);
  List<num>? get topicIds => _topicIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['topic_ids'] = _topicIds;
    return map;
  }

}