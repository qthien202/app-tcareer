import 'package:app_tcareer/src/configs/app_colors.dart';
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.grey.shade50,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {
                    if (controller.selectedProvinces.isNotEmpty) {
                      controller.clearProvince();
                    }
                  },
                  child: Text(
                    "Bỏ chọn tất cả",
                    style: TextStyle(
                        color: controller.selectedProvinces.isNotEmpty
                            ? Colors.black
                            : Colors.grey.shade300,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () async {
                    if (controller.selectedProvinces.isNotEmpty) {
                      await controller.searchFromAddress();
                      context.pop();
                    } else {
                      await controller.refreshSearchJob();
                      context.pop();
                    }
                  },
                  child: const Text(
                    "Áp dụng",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )),
            ),
          ],
        ),
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
              activeColor: AppColors.primary,
              title: Text(province.provinceName ?? ""),
              value:
                  controller.selectedProvinces.contains(province.provinceName),
              onChanged: (isSelected) async => await controller.selectProvince(
                  isSelected: isSelected ?? false,
                  value: province.provinceName ?? ""),
            );
          },
        ),
      ),
    );
  }
}
