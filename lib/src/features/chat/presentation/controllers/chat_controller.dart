import 'dart:async';
import 'dart:convert';

import 'package:app_tcareer/src/features/chat/data/models/conversation.dart';
import 'package:app_tcareer/src/features/chat/data/models/mark_read_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/data/models/send_message_request.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_conversation.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/chat/domain/chat_use_case.dart';
import 'package:app_tcareer/src/features/user/domain/connection_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/snackbar_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../environment/env.dart';

class ChatController extends ChangeNotifier {
  final ChatUseCase chatUseCase;
  final Ref ref;

  ChatController(this.chatUseCase, this.ref) {
    // listenMessage();
  }

  ScrollController scrollController = ScrollController();

  TextEditingController contentController = TextEditingController();

  Conversation? conversationData;
  UserConversation? user;
  List<MessageModel> messages = [];
  String? cachedUserId; // Lưu trữ userId để sử dụng lại

  Future<void> getConversation(String userId) async {
    if (user?.userId.toString() != userId) {
      user = null;
      messages.clear();
      notifyListeners();
    }
    conversationData = await chatUseCase.getConversation(userId);
    if (conversationData?.conversation != user) {
      user = null;
    }
    if (conversationData?.message?.data
            ?.any((message) => messages.contains(message)) ==
        false) {
      messages.clear();
    }
    if (conversationData != null) {
      user = conversationData?.conversation;
      final userJson = jsonEncode(user?.toJson());
      saveUser(userId: userId, userJson: userJson);
      final newConversations = conversationData?.message?.data
          ?.where((newConversation) =>
              !messages.any((messages) => messages.id == newConversation.id))
          .toList();
      messages.addAll(newConversations ?? []);
      await handleDecryptMessage();
      final messageJson =
          jsonEncode(messages.map((message) => message.toJson()).toList());
      await saveMessage(userId: userId, messageJson: messageJson);

      notifyListeners();
    }
  }

  // Đảm bảo rằng bạn đã import thư viện json

  Future<void> handleDecryptMessage() async {
    final key = encrypt.Key.fromBase64(Env.cipherKey);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));

    messages = messages.map((message) {
      final decodedMessage = message.content != null
          ? encrypter.decrypt64(message.content!)
          : null;

      List<String>? mediaUrl;

      if (message.mediaUrl != null) {
        final decryptedMediaUrl = encrypter.decrypt64(message.mediaUrl!);
        print("Decrypted media URL: $decryptedMediaUrl");

        try {
          mediaUrl = List<String>.from(json.decode(decryptedMediaUrl));
        } catch (e) {
          print("Error decoding mediaUrl: $e");
        }
      }

      print(">>>>>>>>>>>>mediaUrlData: $mediaUrl");
      return message.copyWith(content: decodedMessage, mediaUrl: mediaUrl);
    }).toList();
  }

  Future<void> sendMessage(BuildContext context) async {
    AppUtils.futureApi(() async {
      final body = SendMessageRequest(
        conversationId: conversationData?.conversation?.id,
        content: contentController.text,
      );
      contentController.clear();
      setHasContent("");
      await chatUseCase.sendMessage(body).then((val) {});
    }, context, (val) {});
  }

  Future<void> initializeAbly() async => await chatUseCase.initialize();
  StreamSubscription<ably.Message>? messageSubscription;

  Future<StreamSubscription<ably.Message>?> listenMessage() async {
    messageSubscription = await chatUseCase.listenAllMessage(
      conversationId: conversationData?.conversation?.id.toString() ?? "",
      handleChannelMessage: (message) async {
        // print(">>>>>>>>data: ${message.data}");
        await handleUpdateMessage(message);
      },
    );

    return messageSubscription;
  }

  Future<void> handleUpdateMessage(ably.Message message) async {
    final messageData = jsonDecode(message.data.toString());
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    if (messageData['topic'] == "recall") {
      if (clientId != messageData['senderId'].toString()) {
        await handleUpdateMessageRecall(messageData['id']);
      }

      return;
    }
    if (messageData['updatedStatus'] == "delivered" ||
        messageData['updatedStatus'] == "read") {
      final currentMessage = messages.last;
      final updatedMessage =
          currentMessage.copyWith(status: messageData['updatedStatus']);
      messages[messages.length - 1] = updatedMessage;
      notifyListeners();
    } else {
      final mediaUrls = messageData['media_url'] != null
          ? List<String>.from(messageData['media_url'])
          : <String>[];

      final newMessage = MessageModel(
        mediaUrl: mediaUrls,
        content: messageData['content'],
        conversationId: conversationData?.conversation?.id,
        id: messageData['message_id'],
        senderId: messageData['sender_id'],
        status: "sent",
        createdAt:
            messageData['created_at'], // sửa 'createdAt' thành 'created_at'
      );

      if (!messages
          .any((existingMessage) => existingMessage.id == newMessage.id)) {
        messages.removeWhere((message) => message.type == "temp");
        messages.add(newMessage);

        final messageJson =
            jsonEncode(messages.map((message) => message.toJson()).toList());
        saveMessage(
            userId: user?.userId.toString() ?? "", messageJson: messageJson);

        await markReadMessage(
            senderId: messageData['sender_id'].toString(),
            messageId: messageData['message_id']);
        notifyListeners();
      }
    }
  }

  void scrollToBottom() {
    final position = scrollController.position.maxScrollExtent;
    scrollController.jumpTo(position);
  }

  Future<void> markReadMessage(
      {required String senderId, required dynamic messageId}) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    final conversationController = ref.read(conversationControllerProvider);
    final connectionUseCase = ref.watch(connectionUseCaseProvider);
    if (await connectionUseCase.getInMessage() == true) {
      if (clientId != senderId && messages.last.status == "sent" ||
          messages.last.status == "delivered") {
        String data = jsonEncode({
          "topic": "statusMessage",
          "id": messageId,
          "updatedStatus": "read",
          "conversationId": conversationData?.conversation?.id.toString() ?? "",
          "senderId": senderId
        });

        await chatUseCase
            .publishMessage(
                conversationId:
                    conversationData?.conversation?.id.toString() ?? "",
                data: data)
            .then((val) async {
          await conversationController
              .updateUnRead(conversationData?.conversation?.id ?? 0);
        });
        await chatUseCase.postMarkReadMessage(MarkReadMessageRequest(
          conversationId: conversationData?.conversation?.id,
        ));
      }
    }
  }

  StreamSubscription<ably.PresenceMessage>? presenceSubscription;

  StreamSubscription<ably.PresenceMessage>? listenPresence(String userId) {
    presenceSubscription = chatUseCase.listenPresence(
        conversationId: conversationData?.conversation?.id.toString() ?? "",
        handleChannelPresence: (presenceMessage) {
          // print(">>>>>>>>>data: ${presenceMessage.data}");
        });
    return presenceSubscription;
  }

  String? statusText;
  String status = "off";
  Timer? _timer;

  void _startTimer(String dateString) {
    _cancelTimer();
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      statusText = AppUtils.formatTimeMessage(dateString);
      notifyListeners();
    });
  }

  void _cancelTimer() {
    _timer?.cancel(); // Hủy Timer nếu nó đang chạy
    _timer = null;
  }

  Future<void> disposeService() async => await chatUseCase.disconnect();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageSubscription?.cancel();
    presenceSubscription?.cancel();
    scrollController.dispose();
    contentController.dispose();
  }

  bool hasContent = false;

  void setHasContent(String value) {
    if (value.isNotEmpty) {
      hasContent = true;
    } else {
      hasContent = false;
    }
    notifyListeners();
  }

  bool isShowEmoji = false;

  void setIsShowEmoJi(BuildContext context) {
    if (isShowMedia == true) {
      setIsShowMedia(context);
    }

    isShowEmoji = !isShowEmoji;
    if (isShowEmoji == true) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus();
    }
    notifyListeners();
  }

  bool isShowMedia = false;

  Future<void> setIsShowMedia(BuildContext context) async {
    if (isShowEmoji == true) {
      setIsShowEmoJi(context);
    }
    isShowMedia = !isShowMedia;
    if (isShowMedia == true) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus();
    }
    notifyListeners();
  }

  Future<void> sendMessageWithMedia(List<String> mediaUrl) async {
    // await mediaController.getAssetPaths(context);
    // print(">>>>>>>image: ${mediaController.imagePaths}");
    // notifyListeners();

    // if (mediaController.imagePaths.isNotEmpty) {
    //   await mediaController.uploadImage();

    final body = SendMessageRequest(
        conversationId: conversationData?.conversation?.id, mediaUrl: mediaUrl);
    await chatUseCase.sendMessage(body);
    // notifyListeners();

    // setIsShowMedia(context);
  }

  bool isMessageLoaded = false;

  Future<void> onInit(
      {required String clientId, required String userId}) async {
    await loadCache(userId);
    await getConversation(userId);
    await initializeAbly();

    if (messages.isNotEmpty) {
      await markReadMessage(
          senderId: messages.last.senderId.toString(),
          messageId: messages.last.id);
    }
    // listenPresence(userId);
    // listenMessage();
  }

  Future<void> loadCache(String userId) async {
    await loadUser(userId);
    await loadMessage(userId);
  }

  Stream<Map<dynamic, dynamic>> listenUserStatus() {
    String userId = user?.userId.toString() ?? "";
    return chatUseCase.listenUserStatus(userId).map((event) {
      if (event.snapshot.value != null) {
        final userStatus = event.snapshot.value as Map<dynamic, dynamic>;
        // print(">>>>>>>>data");
        return userStatus;
      } else {
        return {};
      }
    });
  }

  Future<void> saveMessage(
      {required String userId, required String messageJson}) async {
    final userUtil = ref.watch(userUtilsProvider);

    await userUtil.saveCache(key: "message_$userId", value: messageJson);
  }

  Future<void> saveUser(
      {required String userId, required String userJson}) async {
    final userUtil = ref.watch(userUtilsProvider);
    await userUtil.saveCache(key: "message_user_$userId", value: userJson);
  }

  Future<void> loadMessage(String userId) async {
    final userUtil = ref.watch(userUtilsProvider);
    String? rawData = await userUtil.loadCache("message_$userId");
    if (rawData != null) {
      final List<dynamic> decodedData = jsonDecode(rawData);
      print(">>>>>>>>>>>>>decodeData: $decodedData");
      List<MessageModel> loadedMessages = decodedData
          .map((data) => MessageModel.fromJson(data as Map<String, dynamic>))
          .toList();
      print(">>>>>>>>>messageCache: ${jsonEncode(loadedMessages)}");
      messages.clear();
      messages.addAll(loadedMessages);
      messages = messages.map((message) {
        List<String>? mediaUrl;

        if (message.mediaUrl != null) {
          try {
            mediaUrl = List<String>.from(message.mediaUrl);
          } catch (e) {
            print("Error decoding mediaUrl: $e");
          }
        }

        return message.copyWith(mediaUrl: mediaUrl);
      }).toList();

      notifyListeners();
    }
  }

  Future<void> loadUser(String userId) async {
    final userUtil = ref.watch(userUtilsProvider);
    String? rawData = await userUtil.loadCache("message_user_$userId");
    if (rawData != null) {
      final Map<dynamic, dynamic> decodedData = jsonDecode(rawData);
      user = UserConversation.fromJson(decodedData);
      notifyListeners();
    }
  }

  Future<void> showModalMessageText({
    bool isMe = false,
    required String message,
    required num messageId,
    required BuildContext context,
  }) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
                onPressed: () async {
                  context.pop();
                  await showConfirmDeleteMessage(messageId, context);
                },
                child: const Text(
                  'Gỡ tin nhắn',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            CupertinoActionSheetAction(
                onPressed: () => copyMessage(message, context),
                child: const Text(
                  'Sao chép',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            Visibility(
              visible: isMe,
              child: CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    context.pop();
                    await showRecallMessage(messageId, context);
                  },
                  child: const Text(
                    'Thu hồi',
                    style: TextStyle(fontSize: 16),
                  )),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              onPressed: () => context.pop()),
        );
      },
    );
  }

  void copyMessage(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      showSnackBar("Sao chép tin nhắn thành công!");
      context.pop();
    });
  }

  Future<void> deleteMessage(num messageId, BuildContext context) async {
    await chatUseCase.putDeleteMessage(messageId.toString()).then((_) async {
      messages.removeWhere((message) => message.id == messageId);
      final messageJson =
          jsonEncode(messages.map((message) => message.toJson()).toList());
      // print(">>>>>>>>messages: $messageJson");
      await saveMessage(
          userId: user?.userId.toString() ?? "", messageJson: messageJson);
      notifyListeners();
      context.pop();
    });
  }

  Future<void> recallMessage(num messageId, BuildContext context) async {
    await chatUseCase.putRecallMessage(messageId.toString()).then((_) async {
      await handleUpdateMessageRecall(messageId);

      await pushNotifyRecallMessage(messageId: messageId);
      context.pop();
    });
  }

  Future<void> pushNotifyRecallMessage({required dynamic messageId}) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    final conversationController = ref.read(conversationControllerProvider);
    final connectionUseCase = ref.watch(connectionUseCaseProvider);
    if (await connectionUseCase.getInMessage() == true) {
      String data = jsonEncode(
          {"topic": "recall", "id": messageId, "senderId": clientId});

      await chatUseCase.publishMessage(
          conversationId: conversationData?.conversation?.id.toString() ?? "",
          data: data);
    }
  }

  Future<void> handleUpdateMessageRecall(dynamic messageId) async {
    final userUtil = ref.watch(userUtilsProvider);
    String clientId = await userUtil.getUserId();
    final currentMessage =
        messages.firstWhere((message) => message.id == messageId);
    final index = messages.indexWhere((message) => message.id == messageId);
    final updateMessage = currentMessage
        .copyWith(content: "", type: "recall", mediaUrl: <String>[]);
    messages[index] = updateMessage;
    // print(">>>>>>>>messageData: ${jsonEncode(messages)}");
    final messageJson =
        jsonEncode(messages.map((message) => message.toJson()).toList());
    // print(">>>>>>>>messages: $messageJson");
    await saveMessage(
        userId: user?.userId.toString() ?? "", messageJson: messageJson);
    notifyListeners();
  }

  Future<void> showConfirmDeleteMessage(
      num messageId, BuildContext context) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Gỡ đối với bạn?'),
        content: const Text(
            'Tin nhắn này sẽ bị gỡ khỏi thiết bị của bạn, nhưng vẫn hiển thị với thành viên khác trong đoạn chat'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.

            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () async {
              await deleteMessage(messageId, context);
            },
            child: const Text('Gỡ bỏ'),
          ),
        ],
      ),
    );
  }

  Future<void> showRecallMessage(num messageId, BuildContext context) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Thu hồi tin nhắn này?'),
        content: const Text(
            'Tin nhắn này sẽ bị thu hồi khỏi cuộc trò chuyện và không thể khôi phục'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.

            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black),
            ),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () async {
              await recallMessage(messageId, context);
            },
            child: const Text('Thu hồi'),
          ),
        ],
      ),
    );
  }

  Future<void> directToMessage(
      {String? content,
      required ItemScrollController itemScrollController}) async {
    final index = messages.indexWhere((message) => message.content == content);

    if (index != -1) {
      final reverseIndex = messages.length - 1 - index;
      itemScrollController.jumpTo(index: reverseIndex);
    }
    notifyListeners();
  }

  double currentIndex = -1;
}

final chatControllerProvider =
    ChangeNotifierProvider.autoDispose<ChatController>((ref) {
  final chatUseCase = ref.read(chatUseCaseProvider);
  ref.keepAlive();
  return ChatController(chatUseCase, ref);
});
