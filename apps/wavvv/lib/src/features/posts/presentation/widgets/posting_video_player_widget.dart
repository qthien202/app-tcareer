import 'dart:io';
import 'package:app_tcareer/src/extensions/video_extension.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';

class PostingVideoPlayerWidget extends ConsumerStatefulWidget {
  final List<String> videoUrl;
  final bool visibleDelete;
  const PostingVideoPlayerWidget(
      {Key? key, this.visibleDelete = true, required this.videoUrl})
      : super(key: key);

  @override
  _PostingVideoPlayerWidgetState createState() =>
      _PostingVideoPlayerWidgetState();
}

class _PostingVideoPlayerWidgetState
    extends ConsumerState<PostingVideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  Future<void> initVideo() async {
    final controller = ref.read(mediaControllerProvider);

    if (widget.videoUrl.isNotEmpty) {
      // Chỉ khởi tạo controller nếu nó chưa được khởi tạo
      if (!_isVideoInitialized) {
        _videoPlayerController = widget.videoUrl.first.isVideo
            ? VideoPlayerController.network(widget.videoUrl.first)
            : VideoPlayerController.file(File(widget.videoUrl.first));

        try {
          await _videoPlayerController.initialize();
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoInitialize: true,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: false,
            looping: false,
            showControls: true,
            showControlsOnInitialize: false,
            showOptions: false,
            zoomAndPan: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.white,
            ),
          );

          setState(() {
            _isVideoInitialized = true;
          });
        } catch (e) {
          debugPrint("Lỗi khởi tạo video: $e");
        }

        _videoPlayerController.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(mediaControllerProvider);
    return VisibilityDetector(
      key: ValueKey(widget.videoUrl),
      child: _isVideoInitialized
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _chewieController!
                          .videoPlayerController.value.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 5,
                    child: Visibility(
                      visible: widget.visibleDelete,
                      child: GestureDetector(
                        onTap: () {
                          // Gọi hàm để xóa video tại index
                          ref.read(mediaControllerProvider).removeVideo();
                        },
                        child: Opacity(
                          opacity: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : videoPlaceholder(),
      onVisibilityChanged: (info) {
        // if (_isVideoInitialized) {
        //   if (info.visibleFraction > 0.8) {
        //     _videoPlayerController.play();
        //   } else {
        //     _videoPlayerController.pause();
        //   }
        // }
      },
    );
  }

  Widget videoPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
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
