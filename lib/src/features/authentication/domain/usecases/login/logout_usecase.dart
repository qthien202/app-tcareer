import 'package:app_tcareer/src/features/authentication/data/models/logout_request.dart';
import 'package:app_tcareer/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:app_tcareer/src/features/authentication/domain/repositories/firebase_auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  final FirebaseAuthRepository _firebaseAuthRepository;
  LogoutUseCase(this._firebaseAuthRepository, this._authRepository);
  Future<void> call(LogoutRequest req) async {
    Future.wait(
        [_firebaseAuthRepository.signOut(), _authRepository.logout(req: req)]);
  }
}
