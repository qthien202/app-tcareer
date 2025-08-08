import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshTokenStateNotifier extends ChangeNotifier {
  bool isRefreshTokenExpired = false;

  void setTokenExpired(bool expired) {
    isRefreshTokenExpired = expired;
  }
}

final refreshTokenStateProvider = ChangeNotifierProvider(
      (ref) => RefreshTokenStateNotifier(),
);