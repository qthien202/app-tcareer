import 'package:app_tcareer/src/features/authentication/domain/repositories/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWithOtpUseCase {
  final FirebaseAuthRepository _repository;
  LoginWithOtpUseCase(this._repository);

  Future<UserCredential?> call(
      {required String smsCode, required String verificationId}) async {
    UserCredential? user;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      user = await _repository.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth: ${e.message}');
      return Future.error(e);
    } catch (e) {
      print('Lỗi không xác định: $e');
      return Future.error(e);
    }
    return user;
  }
}
