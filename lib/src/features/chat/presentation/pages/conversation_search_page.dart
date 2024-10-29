import 'package:app_tcareer/src/features/chat/presentation/controllers/conversation_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:app_tcareer/src/utils/user_utils.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConversationSearchPage extends ConsumerWidget {
  const ConversationSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(conversationControllerProvider);
    // Future.microtask(() {
    //   controller.loadSearchHistory();
    // });
    return PopScope(
      onPopInvoked: (didPop) {
        controller.queryController.clear();
        controller.recentChatters.clear();
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
                visible: controller.recentChatters.isNotEmpty,
                // replacement: emptyWidget("Không có đoạn chat nào!"),
                child: userList(ref, context))),
      ),
    );
  }

  Widget userList(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(conversationControllerProvider);
    final userUtils = ref.watch(userUtilsProvider);
    return Visibility(
      visible: controller.recentChatters.isNotEmpty == true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.recentChatters.length,
        itemBuilder: (context, index) {
          final user = controller.recentChatters[index];
          return ListTile(
            onTap: () async {
              String clientId = await userUtils.getUserId();
              context.pushNamed("chat", pathParameters: {
                "userId": user.id.toString(),
                "clientId": clientId
              });
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar ?? ""),
            ),
            title: Text(user.fullName ?? ""),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}
