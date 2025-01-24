extension FileTypeChecker on String {
  bool get isImageNetWork => this.contains('https://');
}
