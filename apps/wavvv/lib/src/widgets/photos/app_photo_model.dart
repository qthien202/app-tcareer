import 'gallery_item.dart';

class AppPhotoModel {
  List<GalleryItem> medias;
  Function(int)? onPageChanged;
  int index;
  AppPhotoModel(
      {required this.medias, required this.onPageChanged, required this.index});
}
