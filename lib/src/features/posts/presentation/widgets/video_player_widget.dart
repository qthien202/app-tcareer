import 'package:app_tcareer/src/widgets/cached_image_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    _videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    );

    try {
      await _videoPlayerController.initialize();
      // Chỉ tạo ChewieController sau khi videoPlayerController được khởi tạo thành công
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
          showControls: true,
          showControlsOnInitialize: false,
          showOptions: false,
          zoomAndPan: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.white,
          ));

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      // Xử lý lỗi khi không thể khởi tạo video
      debugPrint("Lỗi khởi tạo video: $e");
    }

    // Lắng nghe sự thay đổi của video để cập nhật trạng thái nếu cần
    _videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose(); // Kiểm tra null trước khi dispose
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.videoUrl), // Thay đổi Key thành ValueKey
      child: _isVideoInitialized
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                ),
              ),
            )
          : videoPlaceholder(),
      onVisibilityChanged: (info) {
        if (_isVideoInitialized) {
          if (info.visibleFraction > 0.8) {
            // _videoPlayerController.play();
          } else {
            _videoPlayerController.pause();
          }
        }
      },
    );
  }

  Widget videoPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.black),
          child: circularLoadingWidget(),
        ),
      ),
    );
  }
}
