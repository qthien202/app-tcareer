import 'package:app_tcareer/src/features/authentication/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../utils/user_utils.dart';
import '../../../data/models/login_request.dart';

class LoginUseCase {
  final AuthRepository _repository;
  final UserUtils _util;
  final Ref ref;
  LoginUseCase(this._repository, this._util, this.ref);
  Future<void> call(
      {String? phone, String? email, required String password}) async {
    String deviceToken = await _util.getDeviceToken() ?? "";
    String deviceId = await _util.getDeviceId() ?? "";
    final req = LoginRequest(
        phone: phone,
        email: email,
        password: password,
        deviceToken: deviceToken,
        deviceId: deviceId);
    final response = await _repository.login(req: req);
    final accessToken = response?.accessToken ?? "";
    final refreshToken = response?.refreshToken ?? "";
    final userId = _util.decodeToken(accessToken)['userId'];
    _util.saveAuthToken(
        authToken: accessToken, refreshToken: refreshToken, userId: userId);
    var providers = ref.container.getAllProviderElements();
    for (var element in providers) {
      element.invalidateSelf();
    }
  }
}
