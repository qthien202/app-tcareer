import 'dart:async';
import 'dart:convert';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  final Ref ref;

  ConversationController(this.chatUseCase, this.ref);

  AllConversation? allConversation;
  List<UserConversation> conversations = [];
  Future<void> getAllConversation() async {
    allConversation = null;

    allConversation = await chatUseCase.getAllConversation();
    if (allConversation?.data
            ?.any((conversation) => conversations.contains(conversation)) ==
        false) {
      conversations.clear();
    }
    if (allConversation?.data != null && conversations.isEmpty) {
      // Lọc các cuộc hội thoại để chỉ thêm những cuộc hội thoại có userId không trùng lặp
      final newConversations = allConversation!.data?.where((newConversation) {
        return !conversations.any((existingConversation) =>
            existingConversation.userId == newConversation.userId);
      }).toList();

      // Nếu có cuộc hội thoại mới, thêm vào danh sách
      if (newConversations?.isNotEmpty == true) {
        conversations.addAll(newConversations!);
        final conversationJson = jsonEncode(conversations
            .map((conversation) => conversation.toJson())
            .toList());
        await saveConversation(conversationJson: conversationJson);
        notifyListeners();
      }
    }
  }

  Future<void> addConversation({required dynamic messageData}) async {
    // String lastMessage = messageData['latest_message'].toString();
    // String senderId = messageData['sender_id'].toString();
    // final userUtil = ref.watch(userUtilsProvider);
    // String clientId = await userUtil.getUserId();
    // String senderLastMessage = messageData['sender_latest_message'].toString();
    int conversationId = messageData['conversation_id'] ?? 0;
    // int messageId = messageData['message_id'] ?? 0;
    //
    // String latestMessage =
    //     clientId != senderId ? lastMessage : senderLastMessage;
    // String fullName = clientId == senderId
    //     ? messageData["full_name"]
    //     : messageData['sender_full_name'];
    // String avatar = clientId == senderId
    //     ? messageData['avatar']
    //     : messageData['sender_avatar'];
    // num userId =
    //     clientId != senderId ? messageData['sender_id'] : num.parse(clientId);
    if (!(conversations
        .any((conversation) => conversation.id == conversationId))) {
      await getAllConversation();
      notifyListeners();
    }
  }

  Future<void> updateLastMessage({
    required dynamic messageData,
  }) async {
    String lastMessage = messageData['latest_message'].toString();
    String senderId = messageData['sender_id'].toString();
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    String senderLastMessage = messageData['sender_latest_message'].toString();
    int conversationId = messageData['conversation_id'] ?? 0;
    int messageId = messageData['message_id'] ?? 0;

    String latestMessage =
        clientId != senderId ? lastMessage : senderLastMessage;
    String fullName = clientId == senderId
        ? messageData["full_name"]
        : messageData['sender_full_name'];
    String avatar = clientId == senderId
        ? messageData['avatar']
        : messageData['sender_avatar'];
    num userId =
        clientId != senderId ? messageData['sender_id'] : num.parse(clientId);

    if (conversations
        .any((conversation) => conversation.id == conversationId)) {
      final conversation =
          conversations.firstWhere((e) => e.id == conversationId);
      final newConversation = conversation.copyWith(
        latestMessage: latestMessage,
        updatedAt: DateTime.now().toIso8601String(),
      );

      conversations
          .removeWhere((conversation) => conversation.id == conversationId);
      conversations.insert(0, newConversation);
      notifyListeners();
    }
  }

  Future<void> onInit() async {
    await loadConversationFriends();
    await loadConversation();
    getFriends();
    await getAllConversation();
    await initializeAbly();
    await listenAllConversation();
    print(">>>>>>>>>doneListen");
  }

  Future<void> refresh() async {
    await getFriends();
    await getAllConversation();
  }

  List<StreamSubscription<ably.Message>> messageSubscriptions = [];

  Future<StreamSubscription<ably.Message>?> listenAllConversation() async {
    for (UserConversation conversation in conversations) {
      final subscription = await chatUseCase.listenAllMessage(
        conversationId: conversation.id.toString(),
        handleChannelMessage: (message) async {
          print(">>>>>>>>>conversationData: ${message.data}");

          final messageData = jsonDecode(message.data.toString());
          await updateLastMessage(messageData: messageData);
        },
      );
      messageSubscriptions.add(subscription);
    }

    return messageSubscriptions.isNotEmpty ? messageSubscriptions.first : null;
  }

  Future<void> markDeliveredMessage({
    required String senderId,
    required dynamic messageId,
    required dynamic conversationId,
  }) async {
    // final userUtil = ref.watch(userUtilsProvider);
    // String clientId = await userUtil.getUserId();

    String data = jsonEncode({
      "topic": "statusMessage",
      "id": messageId,
      "updatedStatus": "delivered",
    });
    await chatUseCase
        .publishMessage(conversationId: conversationId.toString(), data: data)
        .catchError((e) {
      print(e);
    });
    chatUseCase.postMarkDeliveredMessage(MarkReadMessageRequest(
      conversationId: conversationId,
    ));
  }

  Future<void> markReadMessage({
    required dynamic senderId,
    required dynamic messageId,
    required dynamic conversationId,
  }) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();

    if (clientId != senderId) {
      String data = jsonEncode(
          {"topic": "statusMessage", "id": messageId, "updatedStatus": "read"});
      await chatUseCase
          .publishMessage(conversationId: conversationId.toString(), data: data)
          .then((val) async {});
    }
    chatUseCase.postMarkReadMessage(MarkReadMessageRequest(
      conversationId: int.parse(conversationId),
    ));
  }

  Future<void> initializeAbly() async => await chatUseCase.initialize();

  Stream<Map<dynamic, dynamic>> listenUsersStatus(String userId) {
    return chatUseCase.listenUsersStatus().map((event) {
      final rawData = event.snapshot.value;
      if (rawData is Map) {
        final usersStatus =
            rawData.entries.where((entry) => entry.value is Map).map((entry) {
          final element = Map<dynamic, dynamic>.from(entry.value);
          element['userId'] = entry.key;
          return element;
        }).toList();
        Map<dynamic, dynamic> userStatus =
            usersStatus.firstWhere((user) => user['userId'] == userId);
        return userStatus;
      }
      return {};
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var subscription in messageSubscriptions) {
      subscription.cancel(); // Huỷ tất cả subscription khi dispose
    }
    // connectSubscription?.cancel();
    super.dispose();
  }

  List<Data> friends = [];
  Future<void> getFriends() async {
    final data = await chatUseCase.getFriendInChat();
    List<dynamic> followerJson = data['data'];
    await mapFriendsFromJson(followerJson);
    notifyListeners();
  }

  Future<void> mapFriendsFromJson(List<dynamic> followerJson) async {
    friends = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
    final friendJson =
        jsonEncode(friends.map((friend) => friend.toJson()).toList());
    saveConversationFriends(friendJson: friendJson);
  }

  StreamSubscription<ably.ConnectionStateChange>? connectSubscription;
  Future<StreamSubscription<ably.ConnectionStateChange>?> listenAblyConnected(
      {required Function(ably.ConnectionStateChange stateChange)
          handleChannelStateChange}) async {
    connectSubscription = await chatUseCase.listenAblyConnected(
        handleChannelStateChange: handleChannelStateChange);
    return connectSubscription;
  }

  Future<void> loadConversation() async {
    final userUtil = ref.watch(userUtilsProvider);
    final String userId = await userUtil.getUserId();
    String? rawData = await userUtil.loadCache("conversation_$userId");
    print(">>>>>>>>>rawData: $rawData");
    if (rawData != null) {
      final List<dynamic> decodedData = jsonDecode(rawData);
      List<UserConversation> loadedConversation = decodedData
          .map(
              (data) => UserConversation.fromJson(data as Map<String, dynamic>))
          .toList();
      conversations.clear();
      conversations.addAll(loadedConversation);
      print(">>>>>>>>>isNot: ${conversations.isNotEmpty}");
      notifyListeners();
    }
  }

  Future<void> saveConversation({required String conversationJson}) async {
    final userUtil = ref.watch(userUtilsProvider);
    final String userId = await userUtil.getUserId();
    await userUtil.saveCache(
        key: "conversation_$userId", value: conversationJson);
  }

  Future<void> saveConversationFriends({required String friendJson}) async {
    final userUtil = ref.watch(userUtilsProvider);
    final String userId = await userUtil.getUserId();
    await userUtil.saveCache(
        key: "conversation_friend_$userId", value: friendJson);
  }

  Future<void> loadConversationFriends() async {
    final userUtil = ref.watch(userUtilsProvider);
    final String userId = await userUtil.getUserId();
    String? rawData = await userUtil.loadCache("conversation_friend_$userId");
    print(">>>>>>>>>rawData: $rawData");
    if (rawData != null) {
      final List<dynamic> decodedData = jsonDecode(rawData);
      List<Data> loadedConversationFriend = decodedData
          .map((data) => Data.fromJson(data as Map<String, dynamic>))
          .toList();
      friends.clear();
      friends.addAll(loadedConversationFriend);

      notifyListeners();
    }
  }
}

final conversationControllerProvider = ChangeNotifierProvider((ref) {
  final chatUseCase = ref.watch(chatUseCaseProvider);

  return ConversationController(chatUseCase, ref);
});
