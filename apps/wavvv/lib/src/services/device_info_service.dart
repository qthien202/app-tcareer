import 'dart:io';

import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceInfoService {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final UserUtils userUtils;
  DeviceInfoService(this.userUtils);
  void configuration() async {
    if (Platform.isAndroid) {
      final android = await deviceInfoPlugin.androidInfo;
      String deviceId = android.id;
      print(">>>>>>deviceId: $deviceId");
      await userUtils.saveDeviceId(deviceId: deviceId);
    } else {
      final ios = await deviceInfoPlugin.iosInfo;
      String deviceId = ios.identifierForVendor ?? "";
      print(">>>>>>deviceId: $deviceId");
      await userUtils.saveDeviceId(deviceId: deviceId);
    }
  }
}

final deviceInfoProvider = Provider<DeviceInfoService>((ref) {
  final userUtils = ref.watch(userUtilsProvider);
  return DeviceInfoService(userUtils);
});
