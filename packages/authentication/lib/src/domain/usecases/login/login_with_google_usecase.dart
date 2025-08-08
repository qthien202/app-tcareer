import 'package:authentication/src/data/models/login_google_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';
import 'package:authentication/src/domain/repositories/firebase_auth_repository.dart';
import 'package:authentication/src/utils/user_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWithGoogleUseCase {
  final FirebaseAuthRepository _firebaseAuthRepository;
  final AuthRepository _authRepository;
  final UserUtils _util;
  final Ref ref;
  LoginWithGoogleUseCase(
      this._firebaseAuthRepository, this._authRepository, this._util, this.ref);
  Future<void> call() async {
    final user = await _loginWithFirebase();
    final accessTokenFirebase = user?.credential?.accessToken;
    String deviceToken = await _util.getDeviceToken() ?? "";
    String deviceId = await _util.getDeviceId() ?? "";
    final req = LoginGoogleRequest(
        accessToken: accessTokenFirebase,
        deviceId: deviceId,
        deviceToken: deviceToken);
    final response = await _authRepository.loginWithGoogle(req: req);
    final accessToken = response?.accessToken ?? "";
    final refreshToken = response?.refreshToken ?? "";
    final userId = _util.decodeToken(accessToken)['sub'];
    _util.saveAuthToken(
        authToken: accessToken, refreshToken: refreshToken, userId: userId);
    var providers = ref.container.getAllProviderElements();
    for (var element in providers) {
      element.invalidateSelf();
    }
  }

  Future<UserCredential?> _loginWithFirebase() async {
    final googleAuth = await _firebaseAuthRepository.signInWithGoogle();
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential =
        await _firebaseAuthRepository.signInWithCredential(credential);
    return userCredential;
  }
}
