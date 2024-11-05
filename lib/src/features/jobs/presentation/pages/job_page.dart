import 'package:app_tcareer/src/features/jobs/data/models/jobs.dart';
import 'package:app_tcareer/src/features/jobs/presentation/widgets/job_item.dart';
import 'package:app_tcareer/src/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JobPage extends ConsumerWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [sliverAppBar(ref, context), recommendJobs()],
        ),
      ),
    );
  }

  Widget sliverAppBar(WidgetRef ref, BuildContext context) {
    // final postingController = ref.watch(postingControllerProvider);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "Công việc",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {},
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
                onTap: () => context.pushNamed("notifications"),
                child: notificationIcon(ref))),
      ],
      // bottom: PreferredSize(
      //   preferredSize: postingController.isLoading == true
      //       ? const Size.fromHeight(30)
      //       : const Size.fromHeight(0),
      //   child: postingLoading(ref),
      // ),
    );
  }

  Widget recommendJobs() {
    List<Jobs> jobs = [
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/cong-ty-tnhh-phan-mem-biwoco-4a2cf060cc228e3769491a7680e919e1-6694e7c9e55e4.jpg",
          name: "Flutter Developer - Lập Trình Viên Flutter",
          hiringCompany: "CÔNG TY TNHH PHẦN MỀM BIWOCO",
          address: "Cái Răng, TP.Cần Thơ"),
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/24MKfDbtC8Bhawm3GqwllRcAyRCDLSUM_1724925438____ad06ff9cedef12b8b9a6dbeba8946ede.png",
          name: "Nhân Viên Mobile Developer (Remote)",
          hiringCompany: "Công Ty TNHH Giải Pháp Công Nghệ CIT",
          address: "TP.Biên Hoà, T.Đồng Nai"),
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/hvcg-software-6144419ae3dd4.jpg",
          name: "Lập Trình Viên .Net ",
          hiringCompany: "HVCG Software",
          address: "Quận Thanh Xuân, Hà Nội"),
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/IKOxhPGCCj8MAXBJZ9qFhcg9KCqYxL2p_1667018832____a200b043ca0dc78984cb5d323ec8c6ec.jpg",
          name: "Senior Fullstack Remote Flexible Time (English) ",
          hiringCompany: "CÔNG TY TNHH METADATA SOLUTIONS",
          address: "Quận 03, TPHCM"),
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/cong-ty-tnhh-systemexe-viet-nam-621f3e210b0f5.jpg",
          name: ".NET Developer - Cần Thơ",
          hiringCompany: "CÔNG TY TNHH SYSTEMEXE VIỆT NAM",
          address: "Ninh Kiều, Cần Thơ"),
      Jobs(
          thumbnailUrl:
              "https://cdn-new.topcv.vn/unsafe/150x/https://static.topcv.vn/company_logos/digiloinc-ab8198c970b4dcb51f4a6c1e9085c166-5e6a2c6cd862e.jpg",
          name: "Full Stack Developer (PHP, VueJS, ReactJS) ",
          hiringCompany: "DIGILO,Inc.",
          address: "Quận 3, Tp Hồ Chí Minh "),
    ];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: jobs.length,
        (context, index) {
          final job = jobs[index];
          return jobItem(job);
        },
      ),
    );
  }
}
