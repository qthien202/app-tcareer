import 'package:authentication/src/data/models/forgot_password_request.dart';
import 'package:authentication/src/data/models/forgot_password_verify_request.dart';
import 'package:authentication/src/data/models/reset_password_request.dart';
import 'package:authentication/src/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_provider.dart';
import '../../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  Future<void> call(ForgotPasswordRequest req) async {
    return await _repository.forgotPassword(req: req);
  }
}
