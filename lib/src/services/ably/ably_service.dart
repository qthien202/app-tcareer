import 'dart:async';
import 'dart:convert';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AblyService {
  late ably.ClientOptions clientOptions; // Sử dụng 'late' để đảm bảo không null
  late ably.Realtime realtime; // Sử dụng 'late' để đảm bảo không null
  final Ref ref;

  AblyService(this.ref);

  Future<void> initialize() async {
    final userUtils = ref.watch(userUtilsProvider);
    String userId = await userUtils.getUserId();
    print(">>>>>>>>>userId: $userId");
    clientOptions = ably.ClientOptions(key: Env.ablyKey, clientId: userId);
    realtime =
        ably.Realtime(options: clientOptions); // Khởi tạo Realtime tại đây
  }

  Future<void> listenAllConnectionState(
      {required Function(ably.ConnectionStateChange)
          handleConnectionState}) async {
    realtime.connection.on().listen((ably.ConnectionStateChange stateChange) {
      handleConnectionState(stateChange);
    });
  }

  Future<void> listenParticularConnectionState(
      {required Function(ably.ConnectionStateChange)
          handleConnectionState}) async {
    realtime.connection
        .on(ably.ConnectionEvent.connected)
        .listen((ably.ConnectionStateChange stateChange) {
      handleConnectionState(stateChange);
    });
  }

  Future<StreamSubscription<ably.Message>> listenAllMessage({
    required String channelName,
    required Function(ably.Message) handleChannelMessage,
  }) async {
    ably.CipherParams cipherParams =
        await ably.Crypto.getDefaultParams(key: Env.cipherKey);
    ably.RealtimeChannelOptions realtimeChannelOptions =
        ably.RealtimeChannelOptions(cipherParams: cipherParams);

    ably.RealtimeChannel channel = realtime.channels.get(
      channelName,
    );
    channel.setOptions(realtimeChannelOptions);
    return channel.subscribe().listen((ably.Message message) {
      handleChannelMessage(message);
    });
  }

  StreamSubscription<ably.Message> listenMessageWithSelectedName(
      {required String channelName,
      required String eventName,
      required Function(ably.Message) handleChannelMessage}) {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    return channel.subscribe(name: eventName).listen((ably.Message message) {
      handleChannelMessage(message);
    });
  }

  Future<void> enterPresence(
      {required String channelName, required String userId}) async {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    String data = jsonEncode({"userId": userId, "status": "online"});
    await channel.presence.enter(data);
  }

  Future<void> leavePresence(
      {required String channelName, required String userId}) async {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    String data = jsonEncode({
      "userId": userId,
      "status": "offline",
      "leavedAt": DateTime.now().toIso8601String()
    });
    await channel.presence.leave(data);
  }

  Future<void> markMessageAsRead(
      {required String channelName, required String userId}) async {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    String data = jsonEncode({'statusMessage': 'read'});
    await channel.presence.enter(data);
  }

  StreamSubscription<ably.PresenceMessage> listenPresence(
      {required String channelName,
      required Function(ably.PresenceMessage) handleChannelPresence}) {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    return channel.presence
        .subscribe()
        .listen((ably.PresenceMessage presenceMessage) {
      handleChannelPresence(presenceMessage);
    });
  }

  Future<void> publishMessage({
    required String channelName,
    required Object data,
  }) async {
    ably.RealtimeChannel channel = realtime.channels.get(channelName);
    await channel.publish(data: data);
  }

  Future<void> disconnect() async {
    await realtime.connection.close();
  }

  Future<void> dispose() async {
    // Hủy tất cả các tài nguyên liên quan
    await disconnect();
    await realtime.close();
  }

  Future<StreamSubscription<ably.ConnectionStateChange>> listenAblyConnected(
      {required Function(ably.ConnectionStateChange stateChange)
          handleChannelStateChange}) async {
    return realtime.connection
        .on()
        .listen((ably.ConnectionStateChange stateChange) async {
      handleChannelStateChange(stateChange);
    });
  }
}

final ablyServiceProvider = Provider<AblyService>((ref) {
  return AblyService(ref);
});
