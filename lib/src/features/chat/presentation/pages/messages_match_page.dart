import 'package:app_tcareer/src/features/chat/data/models/message.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_search_controller.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:flutter/material.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MessagesMatchPage extends ConsumerWidget {
  final Data user;
  const MessagesMatchPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          user.userFullName ?? "",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: user.messages?.length ?? 0,
        itemBuilder: (context, index) {
          final message = user.messages?[index];
          return item(context: context, message: message, ref: ref);
        },
      ),
    );
  }

  Widget item(
      {required WidgetRef ref,
      required BuildContext context,
      MessageModel? message}) {
    final controller = ref.watch(conversationSearchProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return GestureDetector(
      onTap: () async {
        String clientId = await userUtils.getUserId();
        context.pushNamed("chat", pathParameters: {
          "userId": user.userId.toString() ?? "",
          "clientId": clientId,
        }, queryParameters: {
          "content": message?.content
        });
      },
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(message?.senderAvatar ?? ""),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message?.senderFullName ?? "",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            message?.content,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          AppUtils.formatToHourMinute(message?.createdAt ?? ""),
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 1,
                      color: Color(0xffEEEEEE),
                      // color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
