import 'package:photo_manager/photo_manager.dart';

class MediaState {
  final List<AssetPathEntity> albums;
  final List<AssetEntity> media;
  final bool isLoading;
  final bool permissionGranted;
  MediaState({
    required this.albums,
    required this.media,
    this.isLoading = false,
    this.permissionGranted = false,
  });

  MediaState copyWith({
    List<AssetPathEntity>? albums,
    List<AssetEntity>? media,
    bool? isLoading,
    bool? permissionGranted,
  }) {
    return MediaState(
      albums: albums ?? this.albums,
      media: media ?? this.media,
      isLoading: isLoading ?? this.isLoading,
      permissionGranted: permissionGranted ?? this.permissionGranted,
    );
  }
}
