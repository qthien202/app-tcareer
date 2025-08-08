import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/data/models/user_liked.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserLikedPage extends ConsumerStatefulWidget {
  final int? postId;

  final int? commentId;

  const UserLikedPage({this.postId, this.commentId, super.key});

  @override
  ConsumerState<UserLikedPage> createState() => _UserLikedPageState();
}

class _UserLikedPageState extends ConsumerState<UserLikedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      if (widget.postId != null) {
        ref.read(postControllerProvider).getUserLikePost(widget.postId!);
      }
      if (widget.commentId != null) {
        ref
            .read(commentControllerProvider)
            .getUserLikeComment(widget.commentId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postController = ref.watch(postControllerProvider);
    final commentController = ref.watch(commentControllerProvider);
    final postId = widget.postId;
    final users = postId != null
        ? postController.userLiked?.data
        : commentController.userLiked?.data;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Column(
        children: [
          AppBar(
            // toolbarHeight: 30,
            centerTitle: true,
            automaticallyImplyLeading: false,
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
                  "Lượt thích",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            // thickness: 0.1,
            color: Colors.grey.shade200,
          ),
          Visibility(
            visible: users != null,
            replacement: circularLoadingWidget(),
            child: Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: users?.length ?? 0,
                itemBuilder: (context, index) {
                  final user = users?[index];
                  return ListTile(
                      onTap: () => postController.goToProfile(
                          userId: user?.id.toString() ?? "", context: context),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user?.avatar ??
                            "https://ui-avatars.com/api/?name=${user?.fullName}&background=random"),
                      ),
                      title: Text(user?.fullName ?? ""),
                      trailing: Icon(
                        size: 20,
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                      ));
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
