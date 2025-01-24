import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'BASE_URL', obfuscate: false)
  static const String baseUrl = _Env.baseUrl;
  @EnviedField(varName: 'UPLOAD_URL', obfuscate: true)
  static final String uploadUrl = _Env.uploadUrl;

  @EnviedField(varName: 'CLIENT_ID', obfuscate: true)
  static final String clientId = _Env.clientId;

  @EnviedField(varName: 'RESET_PASSWORD_KEY', obfuscate: true)
  static final String resetPasswordKey = _Env.resetPasswordKey;

  @EnviedField(varName: 'UPLOAD_KEY', obfuscate: true)
  static final String uploadKey = _Env.uploadKey;

  @EnviedField(varName: 'ABLY_KEY', obfuscate: true)
  static final String ablyKey = _Env.ablyKey;

  @EnviedField(varName: 'GHN_URL', obfuscate: true)
  static final String addressUrl = _Env.addressUrl;

  @EnviedField(varName: 'CIPHER_KEY', obfuscate: true)
  static final String cipherKey = _Env.cipherKey;

  @EnviedField(varName: 'GHN_TOKEN', obfuscate: true)
  static final String addressToken = _Env.addressToken;
}
