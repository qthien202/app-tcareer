import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        throw Exception("Google authentication failed.");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }

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
    return await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<UserCredential> signInWithOTP(
      {required String smsCode, required String verificationId}) async {
    UserCredential user;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      user = await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Lỗi Firebase Auth: ${e.message}');
      return Future.error(e);
    } catch (e) {
      print('Lỗi không xác định: $e');
      return Future.error(e);
    }
    return user;
  }

  User? get currentUser => auth.currentUser;
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
