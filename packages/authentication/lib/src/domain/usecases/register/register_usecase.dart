import 'package:authentication/src/data/models/register_request.dart';
import 'package:authentication/src/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<void> call(RegisterRequest req) async {
    return await _authRepository.register(req: req);
  }
}
