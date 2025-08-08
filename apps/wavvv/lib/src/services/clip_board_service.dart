import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClipboardService {
  static const MethodChannel _channel =
      MethodChannel('com.example.clipboard/html');

  Future<String?> getHtmlFromClipboard() async {
    try {
      final String? htmlContent = await _channel.invokeMethod('getHtmlContent');
      return htmlContent;
    } on PlatformException catch (e) {
      print("Failed to get HTML from clipboard: ${e.message}");
      return null;
    }
  }
}

final clipboardServiceProvider = Provider((ref) => ClipboardService());
