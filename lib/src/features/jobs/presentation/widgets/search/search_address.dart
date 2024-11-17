import 'package:app_tcareer/src/features/jobs/presentation/controllers/search_job_controller.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchAddress extends ConsumerWidget {
  const SearchAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    if (controller.provinces.isEmpty) {
      Future.microtask(() async => await controller.getProvince());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            automaticallyImplyLeading: true,
            pinned: true,
            centerTitle: false,
            title: Text(
              "Chọn địa điểm",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          sliverProvince(ref)
        ],
      ),
    );
  }

  Widget sliverProvince(WidgetRef ref) {
    final controller = ref.watch(searchJobControllerProvider);
    return SliverVisibility(
      visible: controller.provinces.isNotEmpty,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: controller.provinces.length,
          (context, index) {
            final province = controller.provinces[index];
            bool isLastIndex = controller.provinces.length - index == 1;
            return CheckboxListTile(
              title: Text(province.provinceName ?? ""),
              value: false,
              onChanged: (val) {},
            );
          },
        ),
      ),
    );
  }
}
