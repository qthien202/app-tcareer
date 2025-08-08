import 'dart:io';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  void Function()? onTap;

  ChatVideoPlayerWidget(
    this.videoUrl, {
    this.onTap,
    super.key,
  });

  @override
  _ChatVideoPlayerWidgetState createState() => _ChatVideoPlayerWidgetState();
}

class _ChatVideoPlayerWidgetState extends ConsumerState<ChatVideoPlayerWidget> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.videoUrl,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      ),
      autoPlay: widget.onTap == null,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return flickManager != null && widget.onTap != null
        ? GestureDetector(
            onTap: widget.onTap,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ScreenUtil().screenHeight * .4,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlickVideoPlayer(
                      wakelockEnabledFullscreen: true,
                      flickManager: flickManager!,
                      flickVideoWithControls: FlickVideoWithControls(
                        controls:
                            CustomVideoControls(flickManager: flickManager!),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onTap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: ScreenUtil().screenHeight * .4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlickVideoPlayer(
                flickManager: flickManager!,
                flickVideoWithControls: FlickVideoWithControls(
                  controls: CustomVideoControls(flickManager: flickManager!),
                ),
              ),
            ),
          );
  }
}

// Giao diện điều khiển tùy chỉnh không có nút full screen và ẩn progress bar khi chưa phát
class CustomVideoControls extends StatelessWidget {
  final FlickManager flickManager;

  CustomVideoControls({required this.flickManager});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nút Play/Pause
        Center(
          child: FlickPlayToggle(
            size: 50,
            color: Colors.white,
            playChild: Icon(Icons.play_arrow, size: 50),
            pauseChild: Icon(Icons.pause, size: 50),
          ),
        ),
        // Thanh tua video (chỉ hiển thị khi video đang phát)
        ValueListenableBuilder(
          valueListenable:
              flickManager.flickVideoManager!.videoPlayerController!,
          builder: (context, VideoPlayerValue value, child) {
            return value.isPlaying
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FlickVideoProgressBar(),
                  )
                : SizedBox.shrink(); // Ẩn progress bar khi video chưa phát
          },
        ),
      ],
    );
  }
}
