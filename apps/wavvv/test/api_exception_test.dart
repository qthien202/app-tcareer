import 'package:app_tcareer/src/configs/exceptions/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Tạo lớp mock cho DioException
class MockDioException extends Mock implements DioException {
  @override
  DioExceptionType get type => super.noSuchMethod(Invocation.getter(#type),
      returnValue: DioExceptionType.badResponse); // Giá trị mặc định
}

void main() {
  group('ApiException Tests', () {
    final apiException = ApiException();

    test('bad response exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.badResponse);

      final messages = apiException.getExceptionMessage(exception);

      expect(messages, ["Lỗi phản hồi", "URL API hoặc dữ liệu không hợp lệ."]);
    });

    test('connection error', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.connectionError);

      final messages = apiException.getExceptionMessage(exception);

      expect(messages, ["Lỗi kết nối", "Kiểm tra kết nối mạng."]);
    });

    test('connection timeout', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.connectionTimeout);

      final messages = apiException.getExceptionMessage(exception);

      expect(messages, ["Hết thời gian kết nối", "Kiểm tra lại kết nối."]);
    });

    test('cancel exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.cancel);

      final messages = apiException.getExceptionMessage(exception);

      expect(messages, ["Yêu cầu bị hủy", "Kiểm tra lại yêu cầu."]);
    });

    test('receive timeout exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.receiveTimeout);

      final messages = apiException.getExceptionMessage(exception);

      expect(
          messages, ["Hết thời gian nhận dữ liệu", "Kiểm tra kết nối mạng."]);
    });
  });
}
