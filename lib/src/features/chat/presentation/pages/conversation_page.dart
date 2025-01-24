import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ConversationPage extends ConsumerStatefulWidget {
  const ConversationPage({super.key});

  @override
  ConsumerState<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() async {
      final controller = ref.read(conversationControllerProvider);
      await controller.onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(conversationControllerProvider);

    Future.microtask(() async {
      await controller.listenAllConversation(context);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await controller.refresh(),
            ),
            sliverAppBar(context),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
                child: searchBarWidget(
                    onTap: () => context.goNamed("conversationSearch"),
                    controller: controller.queryController,
                    readOnly: true),
              ),
            ),
            sliverFriend(),
            sliverChat(),
          ],
        ),
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    // final postingController = ref.watch(postingControllerProvider);
    return const SliverAppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true, // AppBar không cố định
      title: Text(
        "Đoạn chat",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget sliverChat() {
    final controller = ref.watch(conversationControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return SliverPadding(
        padding: EdgeInsets.only(
            bottom: controller.conversations.length <= 3 ? 350 : 100),
        sliver: SliverVisibility(
          visible: controller.allConversation != null,
          replacementSliver: SliverToBoxAdapter(
            child: circularLoadingWidget(),
          ),
          sliver: SliverVisibility(
            visible: controller.conversations.isNotEmpty,
            replacementSliver: SliverToBoxAdapter(
              child: emptyWidget("Bạn chưa có đoạn chat nào!"),
            ),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
              childCount: controller.conversations.length,
              (context, index) {
                final conversation = controller.conversations[index];
                bool isLastIndex = controller.conversations.length - index == 1;
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        String clientId = await userUtils.getUserId();
                        context.goNamed("chat", pathParameters: {
                          "userId": conversation.userId.toString() ?? "",
                          "clientId": clientId
                        });
                        print(
                            ">>>>>>>>>>>>conversations: ${controller.conversations}");
                      },
                      leading: Stack(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(
                              conversation.userAvatar ?? "",
                            ),
                          ),
                          // Chấm tròn cắt vào avatar
                          StreamBuilder<Map<dynamic, dynamic>>(
                            stream: controller.listenUsersStatus(
                                conversation.userId.toString()),
                            builder: (context, snapshot) {
                              return Visibility(
                                visible: snapshot.data?['status'] == "online",
                                replacement: Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Visibility(
                                    visible: AppUtils.formatTimeStatusOnline(
                                            snapshot.data?['updatedAt'] != null
                                                ? (snapshot.data?['updatedAt'])
                                                : "") !=
                                        "",
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(
                                        //   color: Colors.white,
                                        //   width: 2,
                                        // ),
                                      ),
                                      child: Text(
                                        AppUtils.formatTimeStatusOnline(
                                            snapshot.data?['updatedAt'] != null
                                                ? (snapshot.data?['updatedAt'])
                                                : ""),
                                        style: const TextStyle(
                                            fontSize: 8, color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 12, // Độ rộng của chấm tròn
                                    height: 12, // Chiều cao của chấm tròn
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green, // Màu của chấm tròn
                                      border: Border.all(
                                        color: Colors
                                            .white, // Đường viền màu trắng để tạo hiệu ứng cắt vào avatar
                                        width: 2, // Độ dày của viền
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            conversation.userFullName ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            AppUtils.formatTimeLastMessage(
                                conversation.updatedAt ?? ""),
                            style: const TextStyle(
                                fontSize: 11, color: Colors.black45),
                          ),
                        ],
                      ),

                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.latestMessage ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Visibility(
                            visible: conversation.unRead != null &&
                                conversation.unRead != 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Text(
                                conversation.unRead.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ),
                          )
                        ],
                      ),
                      // trailing:
                    ),
                    Visibility(
                      visible: !isLastIndex,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().screenWidth * .21),
                        child: const Divider(
                          height: 1,
                          color: Color(0xffEEEEEE),
                          // color: Colors.grey.shade200,
                        ),
                      ),
                    )
                  ],
                );
              },
            )),
          ),
        ));
  }

  Widget sliverFriend() {
    final userUtils = ref.watch(userUtilsProvider);
    final controller = ref.watch(conversationControllerProvider);
    return SliverToBoxAdapter(
      child: Visibility(
        visible: controller.friends.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.friends.length,
              itemBuilder: (context, index) {
                final friend = controller.friends[index];
                return GestureDetector(
                  onTap: () async {
                    String clientId = await userUtils.getUserId();
                    context.goNamed("chat", pathParameters: {
                      "userId": friend.id.toString() ?? "",
                      "clientId": clientId
                    });
                  },
                  child: Container(
                    width: 70, // Đặt chiều rộng cho mỗi avatar
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: CachedNetworkImageProvider(
                                  friend.avatar ?? ""),
                            ),
                            // Chấm tròn cắt vào avatar
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: StreamBuilder<Map<dynamic, dynamic>>(
                                stream: controller
                                    .listenUsersStatus(friend.id.toString()),
                                builder: (context, snapshot) {
                                  return Visibility(
                                    visible:
                                        snapshot.data?['status'] == "online",
                                    child: Container(
                                      width: 15,
                                      height: 15, // Chiều cao của chấm tròn
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Colors.green, // Màu của chấm tròn
                                        border: Border.all(
                                          color: Colors
                                              .white, // Đường viền màu trắng để tạo hiệu ứng cắt vào avatar
                                          width: 2, // Độ dày của viền
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),
                        Text(
                          friend.lastName ?? "",
                          overflow: TextOverflow.ellipsis,
                        ), // Thay đổi tên người bạn
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
