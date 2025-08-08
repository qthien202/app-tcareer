import 'package:authentication/src/data/models/reset_password_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase{
  final AuthRepository _repository;
  ResetPasswordUseCase(this._repository);
  Future<void>call(ResetPasswordRequest req)async{
    return await _repository.resetPassword(req: req);
  }
}