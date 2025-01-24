import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:readmore/readmore.dart';

class ExperienceList extends ConsumerWidget {
  const ExperienceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userController = ref.watch(userControllerProvider);
    final resumeData = userController.resumeModel?.data;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Kinh nghiệm",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
                onTap: () => context.pushNamed("addExperience"),
                child: const PhosphorIcon(PhosphorIconsRegular.plus)),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        itemCount: resumeData?.experience?.length ?? 0,
        itemBuilder: (context, index) {
          final e = resumeData?.experience?[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: () => context.pushNamed("addExperience", extra: e),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PhosphorIcon(PhosphorIconsRegular.bagSimple),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e?.companyName ?? "",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              e?.position ?? "",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "${e?.employmentType} • ${e?.workplaceType}",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Visibility(
                              visible: e?.startDate != "" && e?.endDate != "",
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "${e?.startDate} - ${e?.endDate}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                              e?.jobDescription ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
      ),
    );
  }

  Widget contentWidget(String content, {int trimLines = 5}) {
    return ReadMoreText(
      content,
      trimMode: TrimMode.Line,
      trimLines: trimLines,
      colorClickableText: Colors.black,
      trimCollapsedText: "Xem thêm",
      trimExpandedText: "Thu gọn",
      moreStyle: const TextStyle(fontWeight: FontWeight.bold),
      lessStyle: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
