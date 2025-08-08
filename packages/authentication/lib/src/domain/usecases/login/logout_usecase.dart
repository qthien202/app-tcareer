import 'package:authentication/src/data/models/logout_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';
import 'package:authentication/src/domain/repositories/firebase_auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  final FirebaseAuthRepository _firebaseAuthRepository;
  LogoutUseCase(this._firebaseAuthRepository, this._authRepository);
  Future<void> call(LogoutRequest req) async {
    Future.wait(
        [_firebaseAuthRepository.signOut(), _authRepository.logout(req: req)]);
  }
}
