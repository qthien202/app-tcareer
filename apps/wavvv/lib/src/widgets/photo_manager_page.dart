import 'dart:typed_data';
import 'package:app_tcareer/src/utils/photo_manager_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:intl/intl.dart'; // Để định dạng thời gian

class PhotoManagerPage extends StatefulWidget {
  const PhotoManagerPage({super.key});

  @override
  State<PhotoManagerPage> createState() => _PhotoManagerPageState();
}

class _PhotoManagerPageState extends State<PhotoManagerPage> {
  List<AssetEntity> _mediaList = []; // Danh sách ảnh/video
  bool _loading = true; // Biến để hiển thị loading

  @override
  void initState() {
    super.initState();
    _loadMedia(); // Gọi hàm load ảnh/video
  }

  Future<void> _loadMedia() async {
    // Yêu cầu quyền truy cập ảnh/video
    bool permissionGranted = await PhotoManagerUtils.requestPermission();

    if (permissionGranted) {
      // Lấy danh sách ảnh/video (mặc định là trang 0, size 100)
      List<AssetEntity> media = await PhotoManagerUtils.pickMedia(page: 0);

      // Cập nhật giao diện
      setState(() {
        _mediaList = media;
        _loading = false;
      });
    } else {
      // Hiển thị thông báo nếu không có quyền truy cập
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Picker'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị loading
          : _mediaList.isEmpty
              ? const Center(
                  child:
                      Text('No media found')) // Hiển thị nếu không có ảnh/video
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Số lượng cột
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _mediaList.length,
                  itemBuilder: (context, index) {
                    AssetEntity media = _mediaList[index];

                    return FutureBuilder<Uint8List?>(
                      future:
                          media.thumbnailData, // Lấy thumbnail của ảnh/video
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Stack(
                            children: [
                              // Hiển thị thumbnail
                              Positioned.fill(
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Nếu là video, hiển thị thời gian và nút Play
                              if (media.type == AssetType.video) ...[
                                // Thời gian video
                                Positioned(
                                  bottom: 5,
                                  left: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.black54,
                                    child: Text(
                                      _formatDuration(media.videoDuration),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                // Nút Play
                                const Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ],
                            ],
                          );
                        } else {
                          return const Center();
                        }
                      },
                    );
                  },
                ),
    );
  }

  // Hàm định dạng thời gian video (mm:ss)
  String _formatDuration(Duration duration) {
    return DateFormat('mm:ss').format(DateTime(0).add(duration));
  }
}
