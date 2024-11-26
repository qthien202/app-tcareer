import 'package:app_tcareer/src/features/jobs/presentation/controllers/job_controller.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/empty_widget.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicantsPage extends ConsumerStatefulWidget {
  final num? jobId;
  const ApplicantsPage({super.key, this.jobId});

  @override
  ConsumerState<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends ConsumerState<ApplicantsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final controller = ref.read(jobControllerProvider);
      controller.applicants.clear();
      await controller.getApplicants(widget.jobId ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(jobControllerProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.resetApplicants();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          centerTitle: false,
          title: const Text(
            "Danh sách ứng viên",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          actions: [],
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async =>
                  await controller.refreshApplicant(widget.jobId ?? 0),
            ),
            applicants()
          ],
        ),
      ),
    );
  }

  Widget applicants() {
    final controller = ref.watch(jobControllerProvider);

    return SliverVisibility(
      visible: controller.applicantResponse != null,
      replacementSliver: SliverToBoxAdapter(
        child: circularLoadingWidget(),
      ),
      sliver: SliverVisibility(
        visible: controller.applicants.isNotEmpty,
        replacementSliver: SliverToBoxAdapter(
          child: emptyWidget("Chưa có ứng viên ứng tuyển!"),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final applicant = controller.applicants[index];
              return InkWell(
                onTap: () => context.pushNamed(
                  "applyJob",
                  queryParameters: {"applicationId": applicant.id.toString()},
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(applicant.avatar ?? ""),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              applicant.fullName ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // Text(
                            //   applicant.career ?? "Lập trình viên",
                            //   style: TextStyle(
                            //       fontSize: 12, fontWeight: FontWeight.w300),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              "Xem hồ sơ",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
              return ListTile(
                  tileColor: Colors.white,
                  onTap: () {},
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(applicant.avatar ?? ""),
                  ),
                  title: Text(applicant.fullName ?? ""),
                  trailing: Text(
                    "Xem hồ sơ",
                    style: TextStyle(color: Colors.blue),
                  ));
            },
            childCount: controller.applicants.length, // Số lượng người dùng
          ),
        ),
      ),
    );
  }
}
