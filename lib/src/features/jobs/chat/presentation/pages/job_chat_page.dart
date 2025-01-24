import 'package:app_tcareer/src/features/chat/presentation/widgets/message_box.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/controllers/job_chat_controller.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/pages/media/job_chat_media_page.dart';
import 'package:app_tcareer/src/features/jobs/chat/presentation/widgets/job_chat_bottom_app_bar.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controllers/job_chat_media_controller.dart';
import '../widgets/job_message_box.dart';

class JobChatPage extends ConsumerStatefulWidget {
  final String userId;
  final String clientId;
  final String? content;
  const JobChatPage(
      {super.key, required this.userId, required this.clientId, this.content});

  @override
  ConsumerState<JobChatPage> createState() => _JobChatPageState();
}

class _JobChatPageState extends ConsumerState<JobChatPage> {
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  @override
  void initState() {
    // TODO: implement initState
    Future.microtask(() async {
      final controller = ref.read(jobChatControllerProvider);

      await controller.onInit(clientId: widget.clientId, userId: widget.userId);
      // controller.listenPresence(widget.userId);
      await controller.listenMessage();
      if (widget.content != null) {
        await controller.directToMessage(widget.content ?? "");
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = ref.read(jobChatControllerProvider);

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          await controller.disposeService();
          controller.setHasContent("");
          if (controller.isShowEmoji == true) {
            controller.setIsShowEmoJi(context);
          }
          if (controller.isShowMedia == true) {
            controller.setIsShowMedia(context);
          }

          controller.contentController.clear();
          // ref
          //     .watch(indexControllerProvider.notifier)
          //     .setBottomNavigationBarVisibility(true);
          // context.goNamed("conversation");
        }
      },
      child: Scaffold(
        extendBody: true,

        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade100,
        appBar: appBar(ref),

        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                messages(),
              ],
            ),
            if (controller.isShowMedia)
              DraggableScrollableSheet(
                controller: draggableScrollableController,
                expand: true,
                snap: true,
                initialChildSize: 0.4,
                maxChildSize: 1.0,
                minChildSize: 0.4,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: JobChatMediaPage(
                      scrollController: scrollController,
                      draggableScrollableController:
                          draggableScrollableController,
                    ), // Gọi trang media của bạn
                  );
                },
              ),
            Visibility(
                visible: !controller.isShowMedia,
                child: jobChatBottomAppBar(ref, context)),
          ],
        ),
        bottomNavigationBar: null,

        // bottomNavigationBar:
      ),
    );
  }

  Widget messages() {
    final controller = ref.watch(jobChatControllerProvider);
    final mediaController = ref.watch(jobChatMediaControllerProvider);
    final messages = controller.messages;
    return Expanded(
      // flex: 5,
      child: ScrollablePositionedList.separated(
        reverse: true,
        itemScrollController: controller.itemScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            bottom: controller.isShowMedia
                ? ScreenUtil().screenHeight * .37
                : controller.isShowEmoji
                    ? ScreenUtil().screenHeight * .4
                    : 60,
            top: 5),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          bool isFirstIndex = messages.length - index == messages.length;
          final message = messages.reversed.toList()[index];

          bool isMe = message.senderId.toString() == widget.clientId;
          return jobMessageBox(
              type: message.type,
              context: context,
              isFirstIndex: isFirstIndex,
              status: message.status ?? "",
              avatarUrl: controller.user?.userAvatar ?? "",
              media: message.mediaUrl ?? <String>[],
              ref: ref,
              message: message.content ?? "",
              isMe: isMe,
              createdAt: message.createdAt ?? "",
              messageId: message.id ?? 0);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 2,
        ),
      ),
    );
  }

  PreferredSize appBar(WidgetRef ref) {
    final controller = ref.watch(jobChatControllerProvider);

    return PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leadingWidth: 40,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back),
          ),
          title: StreamBuilder<Map<dynamic, dynamic>>(
            stream: controller.listenUserStatus(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularLoadingWidget();
              }
              final user = snapshot.data;
              return Visibility(
                visible: controller.user != null,
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed('profile', queryParameters: {
                      "userId": controller.user?.userId.toString()
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: user?['status'] == "online",
                            replacement: CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                controller.user?.userAvatar ?? "",
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    controller.user?.userAvatar ?? "",
                                  ),
                                ),
                                // Chấm tròn cắt vào avatar
                                Positioned(
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
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              controller.user?.userFullName ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  user?['status'] == "online"
                                      ? "Đang hoạt động"
                                      : AppUtils.formatTimeMessage(
                                          user?['updatedAt']),
                                  // AppUtils.formatTimeMessage(controller.user?.leftAt),
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ));
  }
}
