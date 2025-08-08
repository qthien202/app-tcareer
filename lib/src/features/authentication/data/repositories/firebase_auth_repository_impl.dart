import 'package:app_tcareer/src/features/authentication/domain/repositories/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  FirebaseAuthRepositoryImpl(this._auth, this._googleSignIn);

  @override
  Future<UserCredential?> signInWithCredential(
      AuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      Future.wait([_googleSignIn.signOut(), _auth.signOut()]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential phoneAuthCredential)
          verificationCompleted,
      required void Function(FirebaseAuthException firebaseAuthException)
          verificationFailed,
      required void Function(String verificationId, int? forceResendingToken)
          codeSent,
      required void Function(String verificationId)
          codeAutoRetrievalTimeout}) async {
    try {
      await _auth.verifyPhoneNumber(
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GoogleSignInAuthentication?> signInWithGoogle() async {
    // TODO: implement signInWithGoogle
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      return googleAuth;
    } catch (e) {
      rethrow;
    }
  }
}
