class PhotoViewData {
  final List<String> images;
  final int index;
  final void Function(int index)? onPageChanged;

  PhotoViewData({
    required this.images,
    required this.index,
    this.onPageChanged,
  });
}
