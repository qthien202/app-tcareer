import 'package:authentication/src/data/models/forgot_password_verify_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';

class ForgotPasswordVerifyUseCase {
  final AuthRepository _repository;
  ForgotPasswordVerifyUseCase(this._repository);
  Future<void> call(ForgotPasswordVerifyRequest req) async {
    return await _repository.forgotPasswordVerify(req: req);
  }
}
