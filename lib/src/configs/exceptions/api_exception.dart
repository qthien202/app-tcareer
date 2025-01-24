import 'package:dio/dio.dart';

class ApiException {
  List<String> getExceptionMessage(DioException exception) {
    switch (exception.type) {
      // case DioExceptionType.badResponse:
      //   return ["Lỗi phản hồi", "URL API hoặc dữ liệu không hợp lệ."];
      case DioExceptionType.connectionError:
        return ["Lỗi kết nối", "Kiểm tra kết nối mạng."];
      case DioExceptionType.connectionTimeout:
        return ["Hết thời gian kết nối", "Kiểm tra lại kết nối."];
      case DioExceptionType.cancel:
        return ["Yêu cầu bị hủy", "Kiểm tra lại yêu cầu."];
      case DioExceptionType.receiveTimeout:
        return ["Hết thời gian nhận dữ liệu", "Kiểm tra kết nối mạng."];
      default:
        return ["Lỗi không xác định", "Vui lòng thử lại sau."];
    }
  }

  List<String> getHttpStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return ["Yêu cầu không hợp lệ", "Kiểm tra tham số."];
      case 401:
        return ["Có lỗi xảy ra", "Tên đăng nhập hoặc mật khẩu sai!"];
      case 403:
        return [
          "Không có quyền",
          "Bạn không được phép thực hiện hành động này."
        ];
      case 404:
        return ["Tài nguyên không tìm thấy", "Kiểm tra URL API."];
      case 500:
        return ["Lỗi máy chủ", "Vui lòng thử lại sau."];
      default:
        return ["Lỗi không xác định", "Liên hệ hỗ trợ nếu cần."];
    }
  }
}
