class AppPhotoModel {
  List<String> images;
  Function(int)? onPageChanged;
  int index;
  AppPhotoModel(
      {required this.images, required this.onPageChanged, required this.index});
}
