import 'package:app_tcareer/src/features/authentication/data/models/forgot_password_verify_request.dart';
import 'package:app_tcareer/src/features/authentication/domain/repositories/auth_repository.dart';
class ForgotPasswordVerifyUseCase {
  final AuthRepository _repository;
  ForgotPasswordVerifyUseCase(this._repository);
  Future<void> call(ForgotPasswordVerifyRequest req) async {
    return await _repository.forgotPasswordVerify(req: req);
  }
}


