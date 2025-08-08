import 'dart:io';

import 'package:app_tcareer/src/features/posts/presentation/controllers/comment_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/comment_item_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:pinput/pinput.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final int postId;
  const CommentsPage(
      {super.key, required this.postId, required this.scrollController});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    final controller =
        ref.read(commentControllerProvider); // Sử dụng read thay vì watch

    // Future.microtask(() {
    //   controller.getCommentByPostId(widget.postId.toString());
    //   // controller.listenToComments(widget.postId.toString());
    // });
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        FocusScope.of(context).unfocus();
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(commentControllerProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        controller.clearRepComment();
        controller.contentController.clear();
        mediaController.removeAssets();
        controller.commentVisibility.clear();
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              appBar(),
              Divider(
                // thickness: 0.1,
                color: Colors.grey.shade200,
              ),
              Expanded(child: items(ref)),
              bottomAppBar(ref, context)
            ],
          ),
          // bottomNavigationBar: bottomAppBar(ref, context),
        ),
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: 50, // Kích thước của AppBar
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0.5,
            toolbarHeight: 50,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 4,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Bình luận",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: const FlexibleSpaceBar(),
          ),
        ],
      ),
    );
  }

  Widget items(WidgetRef ref) {
    final controller = ref.watch(commentControllerProvider);
    return StreamBuilder<Map<dynamic, dynamic>>(
      stream: ref
          .watch(commentControllerProvider)
          .commentsStream(widget.postId.toString()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularLoadingWidget();
        }
        if (snapshot.data?.isEmpty == true) {
          return emptyWidget("Không có bình luận!");
        }
        final commentData = snapshot.data?.entries.toList();
        final comments = commentData
            ?.where((entry) => entry.value['parent_id'] == null)
            .toList();
        return ListView.separated(
          controller: scrollController,
          itemCount: comments?.length ?? 0,
          itemBuilder: (context, index) {
            int commentId = int.parse(comments?[index].key);
            final comment = comments?[index].value;
            final commentsChild =
                controller.getCommentChildren(commentId, commentData!);

            bool isVisible = controller.commentVisibility[commentId] == true;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commentItemWidget(
                    commentId, comment, ref, context, widget.postId.toString()),
                Visibility(
                  visible: commentsChild.isNotEmpty == true,
                  child: Visibility(
                    visible: isVisible,
                    replacement: GestureDetector(
                      onTap: () =>
                          controller.toggleCommentVisibility(commentId),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.grey.shade300,
                              width: 15,
                              height: 2,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Xem ${commentsChild.length} câu trả lời",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: commentsChild.length ?? 0,
                      itemBuilder: (context, ind) {
                        int commentChildId = int.parse(commentsChild[ind].key);
                        final commentChild = commentsChild[ind].value;
                        return commentItemWidget(commentChildId, commentChild,
                            ref, context, widget.postId.toString());
                      },
                    ),
                  ),
                )
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
        );
      },
    );
  }

  Widget commentInput(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(commentControllerProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: controller.parentId != null,
          child: Row(
            children: [
              Text(
                "Đang trả lời ",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                controller.userName ?? "",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () => controller.clearRepComment(),
                  child: Text(
                    "Hủy",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
        TextField(
          style: TextStyle(fontSize: 12),
          textAlignVertical: TextAlignVertical.center,
          onChanged: (val) => controller.setHasContent(val),
          controller: controller.contentController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            suffix: Visibility(
              visible: controller.hasContent,
              child: GestureDetector(
                onTap: () async => await controller.postCreateComment(
                  postId: widget.postId,
                  context: context,
                ),
                child: Container(
                  padding: const EdgeInsets.all(
                      3), // Thêm padding để làm cho nút đẹp hơn
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            hintText: "Thêm bình luận...",
            hintStyle: TextStyle(fontSize: 12),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  Widget bottomAppBar(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(commentControllerProvider);
    final mediaController = ref.watch(mediaControllerProvider);
    final hasAsset = mediaController.imagePaths.isNotEmpty ||
        mediaController.videoThumbnail.isNotEmpty;
    final imagesPath = mediaController.imagePaths;
    String? video = mediaController.videoThumbnail.isNotEmpty
        ? mediaController.videoThumbnail.first
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: hasAsset,
            child: Visibility(
              visible: mediaController.imagePaths.isNotEmpty,
              replacement: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(video ?? ""),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                          onPressed: () => mediaController.removeAssets(),
                          icon: PhosphorIcon(PhosphorIconsBold.xCircle)),
                    )
                  ],
                ),
              ),
              child: Wrap(
                children: imagesPath.map((image) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(image),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                              onPressed: () => mediaController.removeAssets(),
                              icon: PhosphorIcon(PhosphorIconsBold.xCircle)),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
                vertical: 8), // Thêm padding để tạo không gian
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end, // Đặt align cho Row
              children: [
                Visibility(
                  visible: !hasAsset,
                  child: Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (!kIsWeb) {
                              await mediaController.getAlbums();
                              context.pushNamed("photoManager",
                                  queryParameters: {"isComment": "true"});
                            } else {
                              await controller.pickMedia();
                            }
                          },
                          icon: const PhosphorIcon(
                            PhosphorIconsBold.camera,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: commentInput(ref, context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
