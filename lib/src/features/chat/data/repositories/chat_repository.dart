import 'dart:async';
import 'dart:io';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/leave_chat_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';
import 'package:app_tcareer/src/services/ably/ably_service.dart';
import 'package:app_tcareer/src/services/drive/upload_file_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_database_service.dart';
import 'package:app_tcareer/src/services/firebase/firebase_storage_service.dart';
import 'package:app_tcareer/src/services/services.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IChatRepository {
  Future<void> initialize();

  Future<StreamSubscription<ably.Message>> listenAllMessage(
      {required String channelName,
      required Function(ably.Message) handleChannelMessage});

  Future<void> publishMessage(
      {required String channelName, required Object data});

  Future<Conversation> getConversation(String userId, {int? isJob});

  Future<void> sendMessage(SendMessageRequest body);

  Future<void> enterPresence(
      {required String channelName, required String userId});

  Future<void> leavePresence(
      {required String channelName, required String userId});

  StreamSubscription<ably.PresenceMessage> listenPresence(
      {required String channelName,
      required Function(ably.PresenceMessage) handleChannelPresence});

  Future<void> disconnect();

  Future<void> dispose();

  Future<String> uploadImage({required File file, required String folderPath});

  Future<void> putLeavedChat(LeaveChatRequest body);

  Future<String> uploadVideo(
      {required File file, required String folderName, required String topic});

  Future<void> postMarkReadMessage(MarkReadMessageRequest body);

  Future<void> postMarkDeliveredMessage(MarkReadMessageRequest body);

  Future<AllConversation> getAllConversation({int? isJob});

  Stream<DatabaseEvent> listenUserStatus(String userId);

  Future<StreamSubscription<ably.ConnectionStateChange>> listenAblyConnected(
      {required Function(ably.ConnectionStateChange stateChange)
          handleChannelStateChange});

  Stream<DatabaseEvent> listenUsersStatus();

  Future getFriendInChat();

  Future<void> putDeleteMessage(String messageId);

  Future<void> putRecallMessage(String messageId);

  Future<UserFromMessage> getUsersFromMessage(String query);

  Future getRecentChatters(String query);
}

class ChatRepository implements IChatRepository {
  final AblyService ablyServices;
  final ApiServices apiServices;
  final UserUtils userUtils;
  final UploadFileService uploadService;
  final FirebaseStorageService firebaseStorageService;
  final FirebaseDatabaseService firebaseDatabaseService;

  ChatRepository(
      {required this.apiServices,
      required this.ablyServices,
      required this.userUtils,
      required this.firebaseStorageService,
      required this.uploadService,
      required this.firebaseDatabaseService});

  @override
  Future<void> initialize() async => await ablyServices.initialize();

  @override
  Future<StreamSubscription<ably.Message>> listenAllMessage(
          {required String channelName,
          required Function(ably.Message) handleChannelMessage}) async =>
      await ablyServices.listenAllMessage(
          channelName: channelName, handleChannelMessage: handleChannelMessage);

  @override
  Future<void> publishMessage(
          {required String channelName, required Object data}) async =>
      await ablyServices.publishMessage(channelName: channelName, data: data);

  @override
  Future<Conversation> getConversation(String userId, {int? isJob}) async =>
      await apiServices.getConversation(userId: userId, isJob: isJob);

  @override
  Future<void> sendMessage(SendMessageRequest body) async =>
      await apiServices.postSendMessage(body: body);

  @override
  Future<void> enterPresence(
          {required String channelName, required String userId}) async =>
      await ablyServices.enterPresence(
          channelName: channelName, userId: userId);

  @override
  Future<void> leavePresence(
          {required String channelName, required String userId}) async =>
      await ablyServices.leavePresence(
          channelName: channelName, userId: userId);

  @override
  StreamSubscription<ably.PresenceMessage> listenPresence(
      {required String channelName,
      required Function(ably.PresenceMessage) handleChannelPresence}) {
    return ablyServices.listenPresence(
        channelName: channelName, handleChannelPresence: handleChannelPresence);
  }

  @override
  Future<void> disconnect() async {
    return await ablyServices.disconnect();
  }

  @override
  Future<void> dispose() async {
    return await ablyServices.dispose();
  }

  @override
  Future<String> uploadImage(
      {required File file, required String folderPath}) async {
    return await firebaseStorageService.uploadFile(file, folderPath);
  }

  @override
  Future<String> uploadVideo(
      {required File file,
      required String folderName,
      required String topic}) async {
    return await uploadService.uploadFile(
        topic: topic, folderName: folderName, file: file);
  }

  @override
  Future<void> putLeavedChat(LeaveChatRequest body) async {
    return await apiServices.putLeaveChat(body: body);
  }

  @override
  Future<void> postMarkReadMessage(MarkReadMessageRequest body) async {
    return await apiServices.postMarkReadMessage(body: body);
  }

  @override
  Future<void> postMarkDeliveredMessage(MarkReadMessageRequest body) async {
    return await apiServices.postMarkDeliveredMessage(body: body);
  }

  @override
  Future<AllConversation> getAllConversation({int? isJob}) async {
    return await apiServices.getAllConversation(isJob: isJob);
  }

  @override
  Stream<DatabaseEvent> listenUserStatus(String userId) {
    String path = "users/$userId";
    final data = firebaseDatabaseService.listenToData(path);
    return data;
  }

  @override
  Stream<DatabaseEvent> listenUsersStatus() {
    String path = "users";
    final data = firebaseDatabaseService.listenToData(path);
    return data;
  }

  @override
  Future<StreamSubscription<ably.ConnectionStateChange>> listenAblyConnected(
      {required Function(ably.ConnectionStateChange stateChange)
          handleChannelStateChange}) async {
    return await ablyServices.listenAblyConnected(
        handleChannelStateChange: handleChannelStateChange);
  }

  @override
  Future getFriendInChat() async {
    return await apiServices.getFriendInChat();
  }

  @override
  Future<void> putDeleteMessage(String messageId) async {
    return await apiServices.putDeleteMessage(messageId: messageId);
  }

  @override
  Future<void> putRecallMessage(String messageId) async {
    return await apiServices.putRecallMessage(messageId: messageId);
  }

  @override
  Future<UserFromMessage> getUsersFromMessage(String query) async {
    return await apiServices.getUsersFromMessage(query: query);
  }

  @override
  Future getRecentChatters(String query) async {
    return await apiServices.getRecentChatters(query: query);
  }
}

final chatRepositoryProvider = Provider<IChatRepository>((ref) =>
    ChatRepository(
        ablyServices: ref.read(ablyServiceProvider),
        firebaseDatabaseService: ref.read(firebaseDatabaseServiceProvider),
        userUtils: ref.read(userUtilsProvider),
        apiServices: ref.read(apiServiceProvider),
        firebaseStorageService: ref.read(firebaseStorageServiceProvider),
        uploadService: ref.read(uploadFileServiceProvider)));
