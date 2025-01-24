class ApplyJobModel {
  ApplyJobModel({
      num? jobId, 
      String? cvFile, 
      String? note,}){
    _jobId = jobId;
    _cvFile = cvFile;
    _note = note;
}

  ApplyJobModel.fromJson(dynamic json) {
    _jobId = json['job_id'];
    _cvFile = json['cv_file'];
    _note = json['note'];
  }
  num? _jobId;
  String? _cvFile;
  String? _note;
ApplyJobModel copyWith({  num? jobId,
  String? cvFile,
  String? note,
}) => ApplyJobModel(  jobId: jobId ?? _jobId,
  cvFile: cvFile ?? _cvFile,
  note: note ?? _note,
);
  num? get jobId => _jobId;
  String? get cvFile => _cvFile;
  String? get note => _note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['job_id'] = _jobId;
    map['cv_file'] = _cvFile;
    map['note'] = _note;
    return map;
  }

}