import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_search_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:app_tcareer/src/features/chat/data/models/user_from_message.dart';

class ConversationSearchPage extends ConsumerWidget {
  const ConversationSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(conversationSearchProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        controller.recentChatters.clear;
        controller.userMessages.clear();
        controller.userFromMessage = null;
        controller.userRecent = null;
        controller.queryController.text = "";
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 40,
          automaticallyImplyLeading: false,
          title: searchBarWidget(
            controller: controller.queryController,
            onChanged: (val) async => await controller.onSearch(),
            onSubmitted: (val) async => await controller.onSearch(),
          ),
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Visibility(
          visible: !controller.isLoading,
          replacement: circularLoadingWidget(),
          child: Visibility(
            visible: controller.userRecent != null ||
                controller.userFromMessage != null,
            child: Visibility(
              visible: controller.recentChatters.isEmpty &&
                  controller.userMessages.isEmpty,
              child: emptyWidget("Không tìm thấy dữ liệu"),
              replacement: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  // controller: controller.scrollController,
                  slivers: [
                    // CupertinoSliverRefreshControl(
                    //   onRefresh: () async => await controller.refresh(),
                    // ),
                    SliverVisibility(
                      visible: controller.recentChatters.isNotEmpty,
                      sliver: const SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Mọi người",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    userList(ref),
                    SliverVisibility(
                      visible: controller.userFromMessage != null &&
                          controller.userMessages.isNotEmpty &&
                          controller.recentChatters.isNotEmpty,
                      sliver: SliverToBoxAdapter(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: ScreenUtil().scaleWidth,
                        color: Colors.grey.shade100,
                        height: 10,
                      )),
                    ),
                    SliverVisibility(
                      visible: controller.userMessages.isNotEmpty,
                      sliver: const SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Tin nhắn",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    userAndMessage(ref)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userList(WidgetRef ref) {
    final controller = ref.watch(conversationSearchProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final user = controller.recentChatters[index];
          return ListTile(
            onTap: () async {
              String clientId = await userUtils.getUserId();
              context.pushNamed("chat", pathParameters: {
                "userId": user.id.toString() ?? "",
                "clientId": clientId
              });
            },
            tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar ??
                  "https://ui-avatars.com/api/?name=${user.fullName}&background=random"),
            ),
            title: Text(user.fullName ?? ""),
          );
        },
        childCount: controller.recentChatters.length, // Số lượng người dùng
      ),
    );
  }

  Widget userAndMessage(WidgetRef ref) {
    final controller = ref.watch(conversationSearchProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final user = controller.userMessages[index];
          bool isLastIndex = (controller.userMessages.length ?? 0) - index == 1;
          return GestureDetector(
            onTap: () async {
              String clientId = await userUtils.getUserId();
              context.pushNamed("chat", pathParameters: {
                "userId": user.userId.toString() ?? "",
                "clientId": clientId,
              }, queryParameters: {
                "content": user.messages?.first.content
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
                          backgroundImage: NetworkImage(user.userAvatar ?? ""),
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
                                  user.userFullName ?? "",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  user.messages?.first.content,
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                                Visibility(
                                  visible: (user.messages?.length ?? 0) > 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final userData = Data(
                                          userFullName: user.userFullName,
                                          userAvatar: user.userAvatar,
                                          conversationId: user.conversationId,
                                          userId: user.userId,
                                          messages: user.messages,
                                        );

                                        context.goNamed("messagesMatch",
                                            extra: userData);
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${user.messages?.length} kết quả phù hợp",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey,
                                            size: 13,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                AppUtils.formatToHourMinute(
                                    user.messages?.first.createdAt ?? ""),
                                style: TextStyle(color: Colors.black45),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: !isLastIndex,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              color: Color(0xffEEEEEE),
                              // color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: controller.userMessages.length, // Số lượng người dùng
      ),
    );
  }
}
