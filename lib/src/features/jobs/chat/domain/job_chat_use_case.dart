import 'dart:async';
import 'dart:io';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/leave_chat_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';
import 'package:app_tcareer/src/features/chat/data/repositories/chat_repository.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobChatUseCase {
  final IChatRepository chatRepository;
  final Ref ref;
  JobChatUseCase(this.chatRepository, this.ref);

  Future<void> initialize() async => await chatRepository.initialize();

  Future<StreamSubscription<ably.Message>> listenAllMessage(
          {required Function(ably.Message) handleChannelMessage,
          required String conversationId}) async =>
      await chatRepository.listenAllMessage(
          channelName: "conversation-job-$conversationId",
          handleChannelMessage: handleChannelMessage);

  Future<StreamSubscription<ably.Message>> listenAllConversation({
    required Function(ably.Message) handleChannelMessage,
  }) async {
    final userUtil = ref.watch(userUtilsProvider);
    String userId = await userUtil.getUserId();
    return await chatRepository.listenAllMessage(
        channelName: "conversation-job-user-$userId",
        handleChannelMessage: handleChannelMessage);
  }

  Future<void> publishMessage(
      {required String conversationId, required Object data}) async {
    return await chatRepository.publishMessage(
        channelName: "conversation-job-$conversationId", data: data);
  }

  Future<Conversation> getConversation(String userId) async =>
      await chatRepository.getConversation(userId, isJob: 1);

  Future<void> sendMessage(SendMessageRequest body) async =>
      await chatRepository.sendMessage(body);

  Future<void> enterPresence(
          {required String conversationId, required String userId}) async =>
      await chatRepository.enterPresence(
          channelName: "conversation-$conversationId", userId: userId);

  Future<void> leavePresence(
          {required String conversationId, required String userId}) async =>
      await chatRepository.leavePresence(
          channelName: "conversation-$conversationId", userId: userId);

  StreamSubscription<ably.PresenceMessage> listenPresence(
          {required String conversationId,
          required Function(ably.PresenceMessage) handleChannelPresence}) =>
      chatRepository.listenPresence(
          channelName: "conversation-$conversationId",
          handleChannelPresence: handleChannelPresence);

  Future<void> disconnect() async => await chatRepository.disconnect();

  Future<void> dispose() async => await chatRepository.dispose();

  Future<String> uploadImage(
          {required File file, required String folderPath}) async =>
      await chatRepository.uploadImage(file: file, folderPath: folderPath);

  Future<String> uploadVideo(
          {required File file,
          required String folderName,
          required String topic}) async =>
      await chatRepository.uploadVideo(
          file: file, folderName: folderName, topic: topic);

  Future<void> putLeavedChat(LeaveChatRequest body) async =>
      await chatRepository.putLeavedChat(body);

  Future<void> postMarkReadMessage(MarkReadMessageRequest body) async =>
      await chatRepository.postMarkReadMessage(body);

  Future<void> postMarkDeliveredMessage(MarkReadMessageRequest body) async =>
      await chatRepository.postMarkDeliveredMessage(body);

  Future<AllConversation> getAllConversation() async =>
      await chatRepository.getAllConversation(isJob: 1);
  Stream<DatabaseEvent> listenUserStatus(String userId) =>
      chatRepository.listenUserStatus(userId);

  Stream<DatabaseEvent> listenUsersStatus() =>
      chatRepository.listenUsersStatus();

  Future<StreamSubscription<ably.ConnectionStateChange>> listenAblyConnected(
          {required Function(ably.ConnectionStateChange stateChange)
              handleChannelStateChange}) async =>
      await chatRepository.listenAblyConnected(
          handleChannelStateChange: handleChannelStateChange);

  Future getFriendInChat() async => await chatRepository.getFriendInChat();

  Future<void> putDeleteMessage(String messageId) async =>
      await chatRepository.putDeleteMessage(messageId);

  Future<void> putRecallMessage(String messageId) async =>
      await chatRepository.putRecallMessage(messageId);

  Future<UserFromMessage> getUsersFromMessage(String query) async =>
      await chatRepository.getUsersFromMessage(query);
  Future getRecentChatters(String query) async =>
      await chatRepository.getRecentChatters(query);
}

final jobChatUseCaseProvider = Provider<JobChatUseCase>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return JobChatUseCase(chatRepository, ref);
});
