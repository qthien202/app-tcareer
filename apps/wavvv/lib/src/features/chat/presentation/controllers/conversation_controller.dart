import 'dart:async';
import 'dart:convert';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:app_tcareer/src/environment/env.dart';
import 'package:app_tcareer/src/features/chat/data/models/all_conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/chat_controller.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart';
import 'package:app_tcareer/src/features/user/usercases/user_use_case.dart';
import 'package:app_tcareer/src/services/custom_cache_manager.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:developer' as dev;

class ConversationController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  final Ref ref;

  ConversationController(this.chatUseCase, this.ref);

  AllConversation? allConversation;
  List<UserConversation> conversations = [];

  Future<void> getAllConversation() async {
    allConversation = await chatUseCase.getAllConversation();

    final apiConversations = allConversation?.data;

    // Nếu không có dữ liệu từ API, không làm gì cả để tránh mất cache
    if (apiConversations == null || apiConversations.isEmpty) {
      return;
    }

    bool isDifferent = false;

    if (apiConversations.length != conversations.length) {
      isDifferent = true;
    } else {
      for (final apiItem in apiConversations) {
        final localItem = conversations.firstWhere(
          (c) => c.userId == apiItem.userId,
          orElse: () => UserConversation.empty(),
        );

        if (localItem.userId == null ||
            localItem.userAvatar != apiItem.userAvatar ||
            localItem.userFullName != apiItem.userFullName ||
            localItem.latestMessage != apiItem.latestMessage ||
            localItem.unRead != apiItem.unRead) {
          isDifferent = true;
          break;
        }
      }
    }

    if (isDifferent) {
      conversations.clear();
      conversations.addAll(apiConversations);

      await handleDecryptMessage();

      final conversationJson = jsonEncode(
        conversations.map((conversation) => conversation.toJson()).toList(),
      );
      await saveConversation(conversationJson: conversationJson);

      notifyListeners();
    } else {}
  }

  Future<String> handleDecryptLastMessage(String lastMessage) async {
    final rawKey = dotenv.env['CIPHER_KEY'];
    final key = encrypt.Key.fromBase64(rawKey ?? "");
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    String message = encrypter.decrypt64(lastMessage);
    return message;
  }

  Future<void> handleDecryptMessage() async {
    final key = encrypt.Key.fromBase64(Env.cipherKey);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    conversations = conversations.map((conversation) {
      final decodedLatestMessage =
          encrypter.decrypt64(conversation.latestMessage ?? "");

      return conversation.copyWith(latestMessage: decodedLatestMessage);
    }).toList();
  }

  Future<void> updateUnRead(num conversationId) async {
    final currentConversation = conversations
        .firstWhere((conversation) => conversation.id == conversationId);
    final index = conversations
        .indexWhere((conversation) => conversation.id == conversationId);
    final updatedConversation = currentConversation.copyWith(unRead: 0);
    conversations[index] = updatedConversation;
    await refreshCache();
    notifyListeners();
  }

  Future<void> refreshCache() async {
    await saveConversation(conversationJson: jsonEncode(conversations));
    await loadConversation();
  }

  Future<void> updateLastMessage(
      {required dynamic messageData, required BuildContext context}) async {
    String lastMessage = await handleDecryptLastMessage(
        messageData['latest_message'].toString());

    String senderLastMessage = messageData['sender_latest_message'].toString();
    int conversationId = messageData['conversation_id'] ?? 0;
    int messageId = messageData['message_id'] ?? 0;

    String fullName = messageData["full_name"];
    String avatar = messageData['avatar'];
    num unRead = messageData['un_read'];
    num userId = messageData['sender_id'];
    String createdAt = messageData['created_at'].toString();
    num senderId = messageData['sender_message_id'];

    if (conversations.any((conversation) => conversation.userId == userId)) {
      final conversation = conversations.firstWhere((e) => e.userId == userId);
      final newConversation = conversation.copyWith(
        unRead: unRead,
        id: conversationId,
        latestMessage: lastMessage,
        updatedAt: createdAt,
      );

      conversations
          .removeWhere((conversation) => conversation.userId == userId);

      conversations.insert(0, newConversation);
      await refreshCache();
      notifyListeners();
      await markDeliveredMessage(
          context: context,
          senderId: senderId,
          messageId: messageId,
          conversationId: conversationId);
    } else {
      final newConversation = UserConversation(
        unRead: unRead,
        id: conversationId,
        userId: userId,
        userAvatar: avatar,
        userFullName: fullName,
        latestMessage: lastMessage,
        updatedAt: createdAt,
      );

      if (!conversations
          .any((existing) => existing.userId == newConversation.userId)) {
        conversations.insert(0, newConversation);
        await refreshCache();
        notifyListeners();
        await markDeliveredMessage(
            context: context,
            senderId: senderId,
            messageId: messageId,
            conversationId: conversationId);

        // if (messageData['sender_id'] != null) {

        // }
      }
    }
  }

  Future<void> onInit(BuildContext context) async {
    loadConversationFriends();
    await loadConversation();
    await initializeAbly();
    await listenAllConversation(context);
  }

  Future<void> refresh() async {
    await getFriends();
    await getAllConversation();
  }

  StreamSubscription<ably.Message>? conversationSubscriptions;

  Future<StreamSubscription<ably.Message>?> listenAllConversation(
      BuildContext context) async {
    final subscription = await chatUseCase.listenAllConversation(
      handleChannelMessage: (message) async {
        final messageData = jsonDecode(message.data.toString());
        await updateLastMessage(messageData: messageData, context: context);
      },
    );

    return conversationSubscriptions;
  }

  Future<void> markDeliveredMessage(
      {dynamic senderId,
      required dynamic messageId,
      required dynamic conversationId,
      required BuildContext context}) async {
    final userUtil = ref.read(userUtilsProvider);
    String clientId = await userUtil.getUserId();

    final currentConversation = conversations
        .firstWhere((conversation) => conversation.id == conversationId);
    final routerState = GoRouterState.of(context);
    print(">>>>path: ${routerState.fullPath}");
    bool isConversationRoute = routerState.fullPath == ("/conversation");
    if (isConversationRoute && clientId != senderId.toString()) {
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
      await chatUseCase.postMarkDeliveredMessage(MarkReadMessageRequest(
        conversationId: conversationId,
      ));
    }
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
    connectSubscription?.cancel();
    // connectSubscription?.cancel();
    super.dispose();
  }

  List<Data> friends = [];

  Future<void> getFriends() async {
    final userUtil = ref.read(userUtilsProvider);
    final String userId = await userUtil.getUserId();

    final data = await chatUseCase.getFriendInChat();
    final List<dynamic> followerJson = data['data'];
    final fetchedFriends = followerJson
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();

    // 🔹 So sánh với cache hiện tại
    bool hasDifference = fetchedFriends.length != friends.length ||
        fetchedFriends.any((newFriend) {
          final matched = friends.firstWhere(
            (old) => old.id == newFriend.id,
            orElse: () => Data(id: null, fullName: '', avatar: ''),
          );
          return matched.fullName != newFriend.fullName ||
              matched.avatar != newFriend.avatar;
        });

    if (hasDifference) {
      friends = fetchedFriends;
      notifyListeners();

      final friendJson = jsonEncode(friends.map((f) => f.toJson()).toList());

      await CustomCacheManager.instance.putFile(
        'conversation_friend_$userId',
        Uint8List.fromList(utf8.encode(friendJson)),
        fileExtension: 'json',
      );
    }
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
    final userUtil = ref.read(userUtilsProvider);
    final String userId = await userUtil.getUserId();

    final fileInfo = await CustomCacheManager.instance
        .getFileFromCache('conversation_$userId');

    if (fileInfo != null) {
      final jsonStr = utf8.decode(await fileInfo.file.readAsBytes());
      final List<dynamic> decodedData = jsonDecode(jsonStr);

      final List<UserConversation> loadedConversation = decodedData
          .map(
              (data) => UserConversation.fromJson(data as Map<String, dynamic>))
          .toList();

      if (loadedConversation.isNotEmpty) {
        conversations.clear();
        conversations.addAll(loadedConversation);

        notifyListeners();
      }
    }

    // Gọi sau khi load cache, nếu API fail thì conversations vẫn có data từ cache
    await getAllConversation();
  }

  Future<void> saveConversation({required String conversationJson}) async {
    final userUtil = ref.read(userUtilsProvider);
    final String userId = await userUtil.getUserId();

    await CustomCacheManager.instance.putFile(
      'conversation_$userId',
      Uint8List.fromList(utf8.encode(conversationJson)),
      fileExtension: 'json',
    );
  }

  Future<void> saveConversationFriends({required String friendJson}) async {
    final userUtil = ref.read(userUtilsProvider);
    final String userId = await userUtil.getUserId();

    await CustomCacheManager.instance.putFile(
      'conversation_friend_$userId',
      Uint8List.fromList(utf8.encode(friendJson)),
      fileExtension: 'json',
    );
  }

  Future<void> loadConversationFriends() async {
    final userUtil = ref.read(userUtilsProvider);
    final String userId = await userUtil.getUserId();

    final fileInfo = await CustomCacheManager.instance
        .getFileFromCache('conversation_friend_$userId');

    if (fileInfo != null) {
      final jsonStr = utf8.decode(await fileInfo.file.readAsBytes());
      final List decoded = jsonDecode(jsonStr);
      final loadedFriends = decoded
          .map((data) => Data.fromJson(data as Map<String, dynamic>))
          .toList();

      friends.clear();
      friends.addAll(loadedFriends);
      notifyListeners();
    }

    // 🔹 Sau khi load cache thì gọi getFriends() để check cập nhật mới
    await getFriends();
  }

  TextEditingController queryController = TextEditingController();
  List<Data> recentChatters = [];

  Future<void> getRecentChatters() async {
    final data = await chatUseCase.getRecentChatters(queryController.text);
    List<dynamic> chattersJson = data['data'];
    await mapChattersFromJson(chattersJson);
    notifyListeners();
  }

  Future<void> mapChattersFromJson(List<dynamic> jsonData) async {
    recentChatters = jsonData
        .whereType<Map<String, dynamic>>()
        .map((item) => Data.fromJson(item))
        .toList();
    // final friendJson =
    // jsonEncode(friends.map((friend) => friend.toJson()).toList());
    // saveConversationFriends(friendJson: friendJson);
  }

  Future<int> calculateUnReadMessage(BuildContext context) async {
    if (allConversation == null) {
      await getAllConversation();
    }
    int unReadLength = conversations.fold(0, (prev, val) {
      return prev + (val.unRead?.toInt() ?? 0);
    });
    return unReadLength;
  }
}

final conversationControllerProvider = ChangeNotifierProvider((ref) {
  final chatUseCase = ref.read(chatUseCaseProvider);

  return ConversationController(chatUseCase, ref);
});
