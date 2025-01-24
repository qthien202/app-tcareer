class UploadData {
  UploadData({
    String? assetId,
    String? publicId,
    num? version,
    String? versionId,
    String? signature,
    num? width,
    num? height,
    String? format,
    String? resourceType,
    String? createdAt,
    List<dynamic>? tags,
    num? pages,
    num? bytes,
    String? type,
    String? etag,
    bool? placeholder,
    String? url,
    String? secureUrl,
    String? playbackUrl,
    String? assetFolder,
    String? displayName,
    Audio? audio,
    Video? video,
    bool? isAudio,
    num? frameRate,
    num? bitRate,
    num? duration,
    num? rotation,
    String? originalFilename,
    num? nbFrames,
    String? apiKey,
  }) {
    _assetId = assetId;
    _publicId = publicId;
    _version = version;
    _versionId = versionId;
    _signature = signature;
    _width = width;
    _height = height;
    _format = format;
    _resourceType = resourceType;
    _createdAt = createdAt;
    _tags = tags;
    _pages = pages;
    _bytes = bytes;
    _type = type;
    _etag = etag;
    _placeholder = placeholder;
    _url = url;
    _secureUrl = secureUrl;
    _playbackUrl = playbackUrl;
    _assetFolder = assetFolder;
    _displayName = displayName;
    _audio = audio;
    _video = video;
    _isAudio = isAudio;
    _frameRate = frameRate;
    _bitRate = bitRate;
    _duration = duration;
    _rotation = rotation;
    _originalFilename = originalFilename;
    _nbFrames = nbFrames;
    _apiKey = apiKey;
  }

  UploadData.fromJson(dynamic json) {
    _assetId = json['asset_id'];
    _publicId = json['public_id'];
    _version = json['version'];
    _versionId = json['version_id'];
    _signature = json['signature'];
    _width = json['width'];
    _height = json['height'];
    _format = json['format'];
    _resourceType = json['resource_type'];
    _createdAt = json['created_at'];
    if (json['tags'] != null) {
      _tags = [];
      json['tags'].forEach((v) {
        _tags?.add(v);
      });
    }
    _pages = json['pages'];
    _bytes = json['bytes'];
    _type = json['type'];
    _etag = json['etag'];
    _placeholder = json['placeholder'];
    _url = json['url'];
    _secureUrl = json['secure_url'];
    _playbackUrl = json['playback_url'];
    _assetFolder = json['asset_folder'];
    _displayName = json['display_name'];
    _audio = json['audio'] != null ? Audio.fromJson(json['audio']) : null;
    _video = json['video'] != null ? Video.fromJson(json['video']) : null;
    _isAudio = json['is_audio'];
    _frameRate = json['frame_rate'];
    _bitRate = json['bit_rate'];
    _duration = json['duration'];
    _rotation = json['rotation'];
    _originalFilename = json['original_filename'];
    _nbFrames = json['nb_frames'];
    _apiKey = json['api_key'];
  }
  String? _assetId;
  String? _publicId;
  num? _version;
  String? _versionId;
  String? _signature;
  num? _width;
  num? _height;
  String? _format;
  String? _resourceType;
  String? _createdAt;
  List<dynamic>? _tags;
  num? _pages;
  num? _bytes;
  String? _type;
  String? _etag;
  bool? _placeholder;
  String? _url;
  String? _secureUrl;
  String? _playbackUrl;
  String? _assetFolder;
  String? _displayName;
  Audio? _audio;
  Video? _video;
  bool? _isAudio;
  num? _frameRate;
  num? _bitRate;
  num? _duration;
  num? _rotation;
  String? _originalFilename;
  num? _nbFrames;
  String? _apiKey;
  UploadData copyWith({
    String? assetId,
    String? publicId,
    num? version,
    String? versionId,
    String? signature,
    num? width,
    num? height,
    String? format,
    String? resourceType,
    String? createdAt,
    List<dynamic>? tags,
    num? pages,
    num? bytes,
    String? type,
    String? etag,
    bool? placeholder,
    String? url,
    String? secureUrl,
    String? playbackUrl,
    String? assetFolder,
    String? displayName,
    Audio? audio,
    Video? video,
    bool? isAudio,
    num? frameRate,
    num? bitRate,
    num? duration,
    num? rotation,
    String? originalFilename,
    num? nbFrames,
    String? apiKey,
  }) =>
      UploadData(
        assetId: assetId ?? _assetId,
        publicId: publicId ?? _publicId,
        version: version ?? _version,
        versionId: versionId ?? _versionId,
        signature: signature ?? _signature,
        width: width ?? _width,
        height: height ?? _height,
        format: format ?? _format,
        resourceType: resourceType ?? _resourceType,
        createdAt: createdAt ?? _createdAt,
        tags: tags ?? _tags,
        pages: pages ?? _pages,
        bytes: bytes ?? _bytes,
        type: type ?? _type,
        etag: etag ?? _etag,
        placeholder: placeholder ?? _placeholder,
        url: url ?? _url,
        secureUrl: secureUrl ?? _secureUrl,
        playbackUrl: playbackUrl ?? _playbackUrl,
        assetFolder: assetFolder ?? _assetFolder,
        displayName: displayName ?? _displayName,
        audio: audio ?? _audio,
        video: video ?? _video,
        isAudio: isAudio ?? _isAudio,
        frameRate: frameRate ?? _frameRate,
        bitRate: bitRate ?? _bitRate,
        duration: duration ?? _duration,
        rotation: rotation ?? _rotation,
        originalFilename: originalFilename ?? _originalFilename,
        nbFrames: nbFrames ?? _nbFrames,
        apiKey: apiKey ?? _apiKey,
      );
  String? get assetId => _assetId;
  String? get publicId => _publicId;
  num? get version => _version;
  String? get versionId => _versionId;
  String? get signature => _signature;
  num? get width => _width;
  num? get height => _height;
  String? get format => _format;
  String? get resourceType => _resourceType;
  String? get createdAt => _createdAt;
  List<dynamic>? get tags => _tags;
  num? get pages => _pages;
  num? get bytes => _bytes;
  String? get type => _type;
  String? get etag => _etag;
  bool? get placeholder => _placeholder;
  String? get url => _url;
  String? get secureUrl => _secureUrl;
  String? get playbackUrl => _playbackUrl;
  String? get assetFolder => _assetFolder;
  String? get displayName => _displayName;
  Audio? get audio => _audio;
  Video? get video => _video;
  bool? get isAudio => _isAudio;
  num? get frameRate => _frameRate;
  num? get bitRate => _bitRate;
  num? get duration => _duration;
  num? get rotation => _rotation;
  String? get originalFilename => _originalFilename;
  num? get nbFrames => _nbFrames;
  String? get apiKey => _apiKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['asset_id'] = _assetId;
    map['public_id'] = _publicId;
    map['version'] = _version;
    map['version_id'] = _versionId;
    map['signature'] = _signature;
    map['width'] = _width;
    map['height'] = _height;
    map['format'] = _format;
    map['resource_type'] = _resourceType;
    map['created_at'] = _createdAt;
    if (_tags != null) {
      map['tags'] = _tags?.map((v) => v.toJson()).toList();
    }
    map['pages'] = _pages;
    map['bytes'] = _bytes;
    map['type'] = _type;
    map['etag'] = _etag;
    map['placeholder'] = _placeholder;
    map['url'] = _url;
    map['secure_url'] = _secureUrl;
    map['playback_url'] = _playbackUrl;
    map['asset_folder'] = _assetFolder;
    map['display_name'] = _displayName;
    if (_audio != null) {
      map['audio'] = _audio?.toJson();
    }
    if (_video != null) {
      map['video'] = _video?.toJson();
    }
    map['is_audio'] = _isAudio;
    map['frame_rate'] = _frameRate;
    map['bit_rate'] = _bitRate;
    map['duration'] = _duration;
    map['rotation'] = _rotation;
    map['original_filename'] = _originalFilename;
    map['nb_frames'] = _nbFrames;
    map['api_key'] = _apiKey;
    return map;
  }
}

class Video {
  Video({
    String? pixFormat,
    String? codec,
    num? level,
    String? profile,
    String? bitRate,
    String? dar,
    String? timeBase,
  }) {
    _pixFormat = pixFormat;
    _codec = codec;
    _level = level;
    _profile = profile;
    _bitRate = bitRate;
    _dar = dar;
    _timeBase = timeBase;
  }

  Video.fromJson(dynamic json) {
    _pixFormat = json['pix_format'];
    _codec = json['codec'];
    _level = json['level'];
    _profile = json['profile'];
    _bitRate = json['bit_rate'];
    _dar = json['dar'];
    _timeBase = json['time_base'];
  }
  String? _pixFormat;
  String? _codec;
  num? _level;
  String? _profile;
  String? _bitRate;
  String? _dar;
  String? _timeBase;
  Video copyWith({
    String? pixFormat,
    String? codec,
    num? level,
    String? profile,
    String? bitRate,
    String? dar,
    String? timeBase,
  }) =>
      Video(
        pixFormat: pixFormat ?? _pixFormat,
        codec: codec ?? _codec,
        level: level ?? _level,
        profile: profile ?? _profile,
        bitRate: bitRate ?? _bitRate,
        dar: dar ?? _dar,
        timeBase: timeBase ?? _timeBase,
      );
  String? get pixFormat => _pixFormat;
  String? get codec => _codec;
  num? get level => _level;
  String? get profile => _profile;
  String? get bitRate => _bitRate;
  String? get dar => _dar;
  String? get timeBase => _timeBase;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pix_format'] = _pixFormat;
    map['codec'] = _codec;
    map['level'] = _level;
    map['profile'] = _profile;
    map['bit_rate'] = _bitRate;
    map['dar'] = _dar;
    map['time_base'] = _timeBase;
    return map;
  }
}

class Audio {
  Audio({
    String? codec,
    String? bitRate,
    num? frequency,
    num? channels,
    String? channelLayout,
  }) {
    _codec = codec;
    _bitRate = bitRate;
    _frequency = frequency;
    _channels = channels;
    _channelLayout = channelLayout;
  }

  Audio.fromJson(dynamic json) {
    _codec = json['codec'];
    _bitRate = json['bit_rate'];
    _frequency = json['frequency'];
    _channels = json['channels'];
    _channelLayout = json['channel_layout'];
  }
  String? _codec;
  String? _bitRate;
  num? _frequency;
  num? _channels;
  String? _channelLayout;
  Audio copyWith({
    String? codec,
    String? bitRate,
    num? frequency,
    num? channels,
    String? channelLayout,
  }) =>
      Audio(
        codec: codec ?? _codec,
        bitRate: bitRate ?? _bitRate,
        frequency: frequency ?? _frequency,
        channels: channels ?? _channels,
        channelLayout: channelLayout ?? _channelLayout,
      );
  String? get codec => _codec;
  String? get bitRate => _bitRate;
  num? get frequency => _frequency;
  num? get channels => _channels;
  String? get channelLayout => _channelLayout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['codec'] = _codec;
    map['bit_rate'] = _bitRate;
    map['frequency'] = _frequency;
    map['channels'] = _channels;
    map['channel_layout'] = _channelLayout;
    return map;
  }
}
