class GalleryItem {
  final String? fullName;
  final String? avatarUrl;
  final String? createdAt;
  final String mediaUrl;

  // Constructor
  GalleryItem({
    this.fullName,
    this.avatarUrl,
    this.createdAt,
    required this.mediaUrl,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      createdAt: json['createdAt'] as String,
      mediaUrl: json['mediaUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt,
      'mediaUrl': mediaUrl,
    };
  }
}
