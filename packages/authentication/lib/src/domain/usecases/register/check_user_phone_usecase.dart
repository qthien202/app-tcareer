import 'package:authentication/src/data/models/check_user_phone_request.dart';
import 'package:authentication/src/data/models/register_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';

class CheckUserPhoneUseCase {
  final AuthRepository _authRepository;

  CheckUserPhoneUseCase(this._authRepository);

  Future<void> call(CheckUserPhoneRequest req) async {
    return await _authRepository.checkUserPhone(req: req);
  }
}
