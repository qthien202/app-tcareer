import '../../../data/models/verify_phone_request.dart';
import '../../repositories/auth_repository.dart';

class VerifyPhoneUseCase {
  final AuthRepository _authRepository;

  VerifyPhoneUseCase(this._authRepository);

  Future<void> call({required VerifyPhoneRequest req}) async {
    return await _authRepository.verifyPhoneNumber(req: req);
  }
}
