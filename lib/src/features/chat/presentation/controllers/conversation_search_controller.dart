import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';
import 'package:app_tcareer/src/features/chat/usecases/chat_use_case.dart';
import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart' as user;
import 'package:go_router/go_router.dart';

class ConversationSearchController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  ConversationSearchController(this.chatUseCase);

  TextEditingController queryController = TextEditingController();
  List<user.Data> recentChatters = [];
  dynamic userRecent;
  Future<void> getRecentChatters() async {
    userRecent = await chatUseCase.getRecentChatters(queryController.text);
    List<dynamic> chattersJson = userRecent['data'];
    await mapChattersFromJson(chattersJson);
    notifyListeners();
  }

  Future<void> mapChattersFromJson(List<dynamic> jsonData) async {
    recentChatters = jsonData
        .whereType<Map<String, dynamic>>()
        .map((item) => user.Data.fromJson(item))
        .toList();
    // final friendJson =
    // jsonEncode(friends.map((friend) => friend.toJson()).toList());
    // saveConversationFriends(friendJson: friendJson);
  }

  final Debouncer debouncer = Debouncer(milliseconds: 1000);
  bool isLoading = false;

  void setIsLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  Future<void> onSearch() async {
    debouncer.run(() async {
      setIsLoading(true);
      if (queryController.text.isNotEmpty) {
        await getRecentChatters();
        await getUserFromMessage();
      } else {
        recentChatters.clear();
        notifyListeners();
      }
      setIsLoading(false);
    });
  }

  UserFromMessage? userFromMessage;

  List<Data> userMessages = [];
  Future<void> getUserFromMessage() async {
    userMessages.clear();
    userFromMessage =
        await chatUseCase.getUsersFromMessage(queryController.text);
    // final newUserFromMessage = userFromMessage?.data
    //     ?.where((e) => !userMessages.any((user) =>
    //         user.conversationId == e.conversationId && user.userId == e.userId))
    //     .toList();

    userMessages.addAll(userFromMessage?.data as Iterable<Data>);
    await handleDecryptMessage();
    print(">>>>>>>>>>>>userMessage: ${jsonEncode(userMessages)}");
    notifyListeners();
  }

  List<MessageModel> messagesMatch = [];
  Future<void> setMessageMatch(List<MessageModel> messages) async {
    messagesMatch.clear();
    messagesMatch.addAll(messages);
    notifyListeners();
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
    final rawKey = dotenv.env['CIPHER_KEY'];
    final key = encrypt.Key.fromBase64(rawKey ?? "");
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));

    for (var e in userMessages) {
      if (e.messages != null) {
        for (var i = 0; i < e.messages!.length; i++) {
          final newContent = encrypter.decrypt64(e.messages![i].content);
          e.messages![i] = e.messages![i].copyWith(content: newContent);
        }
      }
    }

    notifyListeners();
  }
}

final conversationSearchProvider = ChangeNotifierProvider(
    (ref) => ConversationSearchController(ref.read(chatUseCaseProvider)));
