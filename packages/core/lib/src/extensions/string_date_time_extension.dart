// extensions/string_datetime_extension.dart

import 'package:core/core.dart';
import 'package:intl/intl.dart';

extension StringDateTimeExtension on String {
  DateTime toDateTime({DateTime? fallback}) {
    try {
      return DateTime.parse(AppUtils.convertToISOFormat(this));
    } catch (_) {
      return fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  int compareToDateTime(String other, {DateTime? fallback}) {
    return toDateTime(fallback: fallback)
        .compareTo(other.toDateTime(fallback: fallback));
  }

  String toHourMinute() {
    DateTime dateTime = DateTime.parse(this);
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatTimeStatusOnline() {
    final dateString = replaceAll('/', '-');
    final dateTime = DateTime.tryParse(dateString);
    if (dateTime == null) {
      return '';
    }
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Vài giây';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày';
    } else if (difference.inDays < 14) {
      return '1 tuần';
    } else {
      return "";
    }
  }

  String formatTimeLastMessage() {
    final dateString = replaceAll('/', '-');

    final dateTime = DateTime.tryParse(dateString);
    if (dateTime == null) {
      return 'Invalid date format';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Vài giây trước';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày';
    } else if (difference.inDays < 14) {
      return '1 tuần';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  String formatTimeMessage() {
    final dateString = replaceAll('/', '-');

    final dateTime = DateTime.tryParse(dateString);
    if (dateTime == null) {
      return "";
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Hoạt động vài giây trước';
    } else if (difference.inMinutes < 60) {
      return 'Hoạt động ${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return 'Hoạt động ${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return 'Hoạt động ${difference.inDays} ngày trước';
    } else if (difference.inDays < 14) {
      return 'Hoạt động 1 tuần trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  String formatCreatedAt() {
    DateTime dateTime = DateTime.parse(this);

    // Định dạng giờ phút
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }

  String convertToISOFormat() {
    return replaceAll('/', '-').replaceFirst(' ', 'T');
  }

  String formatDateTime() {
    try {
      DateFormat inputFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

      DateFormat outputFormat = DateFormat('dd/MM/yyyy HH:mm');

      final date = trim();

      DateTime dateTime = inputFormat.parse(date);

      return outputFormat.format(dateTime);
    } catch (e) {
      print("Lỗi format date: $e");
      return "Ngày không hợp lệ";
    }
  }

  String formatDate() {
    DateTime dateTime = DateTime.parse(this);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }
}
