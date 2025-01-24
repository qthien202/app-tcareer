import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';

class VideoPlayerControllerNotifier extends ChangeNotifier {
  VideoPlayerController? videoPlayerController;
  String? currentVideoUrl;

  // Khởi tạo video player
  void initializePlayer(String videoUrl) async {
    if (videoPlayerController == null || currentVideoUrl != videoUrl) {
      disposePlayer();
      videoPlayerController = VideoPlayerController.network(videoUrl)
        ..setLooping(false);

      await videoPlayerController!.initialize(); // Chờ khởi tạo
      notifyListeners(); // Chỉ notify sau khi khởi tạo xong
      currentVideoUrl = videoUrl;
    }
  }

  void disposePlayer() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    notifyListeners();
  }
}

final videoPlayerProvider =
    ChangeNotifierProvider.family<VideoPlayerControllerNotifier, String>(
  (ref, videoUrl) {
    final controller = VideoPlayerControllerNotifier();
    ref.onDispose(() => controller
        .disposePlayer()); // Dispose controller when the provider is disposed
    controller.initializePlayer(videoUrl);
    return controller;
  },
);
