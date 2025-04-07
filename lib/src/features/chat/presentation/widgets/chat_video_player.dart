import 'dart:io';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayerWidget extends ConsumerStatefulWidget {
  // Đường dẫn đến file video
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
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
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
            onTap: widget.onTap, // Bắt sự kiện nhấn
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: ScreenUtil().screenHeight * .4,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FlickVideoPlayer(
                      flickManager: flickManager!,
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors
                          .transparent, // Đảm bảo không ảnh hưởng đến giao diện
                      child: InkWell(
                        onTap: widget.onTap, // Khi nhấn vào vùng ngoài video
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
              ),
            ),
          );
  }
}
