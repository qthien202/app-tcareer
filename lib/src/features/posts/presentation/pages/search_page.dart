import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchPostControllerProvider);
    Future.microtask(() {
      controller.loadSearchHistory();
    });
    return PopScope(
      onPopInvoked: (didPop) {
        controller.quickSearchData.data?.clear();
        controller.queryController.clear();
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
              onSubmitted: (val) =>
                  context.goNamed("searchResult", queryParameters: {"q": val})),
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Visibility(
            visible: controller.quickSearchData.data?.isNotEmpty == true,
            replacement: searchHistory(ref),
            child: userList(ref, context)),
      ),
    );
  }

  Widget userList(WidgetRef ref, BuildContext context) {
    final controller = ref.watch(searchPostControllerProvider);
    final postController = ref.watch(postControllerProvider);
    return Visibility(
      visible: controller.quickSearchData.data?.isNotEmpty == true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.quickSearchData.data?.length ?? 0,
        itemBuilder: (context, index) {
          final user = controller.quickSearchData.data?[index];
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
    );
  }

  Widget searchHistory(WidgetRef ref) {
    final controller = ref.watch(searchPostControllerProvider);
    return Visibility(
      visible: controller.searchHistory.isNotEmpty,
      child: ListView(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final query = controller.searchHistory[index];
              return ListTile(
                onTap: () {
                  controller.queryController.text = query;
                  context.goNamed("searchResult",
                      queryParameters: {"q": controller.queryController.text});
                },
                leading: Icon(
                  Icons.history,
                  color: Colors.grey,
                ),
                title: Text(query),
                trailing: GestureDetector(
                  onTap: () => controller.removeSearchHistory(index),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 15,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
          ),
          Visibility(
            visible: controller.searchHistory.length >= 5,
            child: Center(
              child: GestureDetector(
                onTap: () => controller.clearSearchHistory(),
                child: Text(
                  "Xóa tất cả",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
