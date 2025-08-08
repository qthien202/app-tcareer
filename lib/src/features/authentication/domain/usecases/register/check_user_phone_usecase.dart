import 'package:app_tcareer/src/features/authentication/data/models/check_user_phone_request.dart';
import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/domain/repositories/auth_repository.dart';

class CheckUserPhoneUseCase {
  final AuthRepository _authRepository;

  CheckUserPhoneUseCase(this._authRepository);

  Future<void> call(CheckUserPhoneRequest req) async {
    return await _authRepository.checkUserPhone(req: req);
  }
}
