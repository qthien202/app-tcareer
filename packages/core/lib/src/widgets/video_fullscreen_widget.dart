import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreenWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  final void Function()? onTap;

  const VideoFullScreenWidget(
    this.videoUrl, {
    this.onTap,
    super.key,
  });

  @override
  _VideoFullScreenWidgetState createState() => _VideoFullScreenWidgetState();
}

class _VideoFullScreenWidgetState extends ConsumerState<VideoFullScreenWidget> {
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

class CustomVideoControls extends StatelessWidget {
  final FlickManager flickManager;

  const CustomVideoControls({required this.flickManager});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nút Play/Pause
        const Center(
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
                : const SizedBox
                    .shrink(); // Ẩn progress bar khi video chưa phát
          },
        ),
      ],
    );
  }
}
