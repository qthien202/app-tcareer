// file_type_checker.dart
extension FileTypeChecker on String {
  bool get isVideo =>
      this.contains('https://res.cloudinary.com') ||
      this.contains("https://drive.google.com/uc?export=download&id=");

  bool get isVideoNetWork => this.contains('https://res.cloudinary.com');

  bool get isVideoLocal {
    // Lấy phần mở rộng của file từ chuỗi đường dẫn
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];
    return videoExtensions.any((ext) => this.toLowerCase().endsWith(ext));
  }
}

extension ListFileTypeChecker on List<String> {
  bool get hasVideos => any((url) => url.isVideo);
}
