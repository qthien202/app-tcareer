import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthRepository {
  Future<GoogleSignInAuthentication?> signInWithGoogle();

  Future<UserCredential?> signInWithCredential(AuthCredential credential);
  Future<void> signOut();
  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required void Function(PhoneAuthCredential phoneAuthCredential)
          verificationCompleted,
      required void Function(FirebaseAuthException firebaseAuthException)
          verificationFailed,
      required void Function(String verificationId, int? forceResendingToken)
          codeSent,
      required void Function(String verificationId) codeAutoRetrievalTimeout});
}
