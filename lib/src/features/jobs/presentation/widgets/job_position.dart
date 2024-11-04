import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';

class JobPosition extends StatelessWidget {
  final ScrollController scrollController;
  const JobPosition({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    List<String> jobs = [
      // Công nghệ thông tin
      "Kỹ sư phần mềm",
      "Lập trình viên web",
      "Lập trình viên di động",
      "Kỹ sư dữ liệu (Data Engineer)",
      "Khoa học dữ liệu (Data Scientist)",
      "Chuyên viên an ninh mạng",
      "Quản trị hệ thống",
      "Chuyên viên hỗ trợ kỹ thuật (IT Support)",
      "Kỹ sư trí tuệ nhân tạo (AI Engineer)",
      "Chuyên viên DevOps",

      // Kinh doanh và Quản lý
      "Nhân viên kinh doanh (Sales)",
      "Quản lý dự án",
      "Quản lý sản phẩm (Product Manager)",
      "Chuyên viên marketing",
      "Nhân viên chăm sóc khách hàng",
      "Chuyên viên nhân sự (HR Specialist)",
      "Chuyên viên tài chính",
      "Nhà phân tích kinh doanh (Business Analyst)",
      "Chuyên viên phát triển kinh doanh (Business Development)",

      // Thiết kế và Sáng tạo
      "Thiết kế đồ họa (Graphic Designer)",
      "Thiết kế UX/UI",
      "Nhiếp ảnh gia",
      "Biên tập video",
      "Nhà sản xuất nội dung (Content Creator)",
      "Chuyên viên truyền thông xã hội (Social Media Specialist)",
      "Biên tập viên (Editor)",
      "Nhà thiết kế thời trang",

      // Giáo dục và Đào tạo
      "Giáo viên tiểu học/trung học",
      "Giảng viên đại học",
      "Giáo viên ngoại ngữ",
      "Gia sư",
      "Huấn luyện viên kỹ năng mềm",
      "Chuyên viên đào tạo nội bộ",

      // Y tế và Chăm sóc sức khỏe
      "Bác sĩ",
      "Y tá",
      "Dược sĩ",
      "Chuyên viên vật lý trị liệu",
      "Chuyên viên dinh dưỡng",
      "Nhà tâm lý học",
      "Kỹ thuật viên xét nghiệm",

      // Xây dựng và Kỹ thuật
      "Kỹ sư xây dựng",
      "Kỹ sư cơ khí",
      "Kỹ sư điện",
      "Kỹ sư môi trường",
      "Kiến trúc sư",
      "Kỹ sư tự động hóa",
      "Kỹ sư dầu khí",

      // Sản xuất và Vận hành
      "Công nhân sản xuất",
      "Quản lý kho",
      "Nhân viên logistics",
      "Tài xế giao hàng",
      "Nhân viên kiểm tra chất lượng (QC)",
      "Nhân viên vận hành máy",

      // Dịch vụ và Nhà hàng - Khách sạn
      "Nhân viên phục vụ nhà hàng",
      "Đầu bếp",
      "Nhân viên lễ tân",
      "Quản lý nhà hàng",
      "Nhân viên buồng phòng",
      "Nhân viên chăm sóc khách hàng khách sạn",

      // Tài chính và Ngân hàng
      "Chuyên viên phân tích tài chính",
      "Nhân viên tín dụng",
      "Chuyên viên kiểm toán",
      "Nhân viên ngân hàng",
      "Nhân viên bảo hiểm",
      "Cố vấn tài chính",

      // Truyền thông và Quảng cáo
      "Chuyên viên PR (Quan hệ công chúng)",
      "Nhà hoạch định truyền thông (Media Planner)",
      "Chuyên viên quảng cáo",
      "Nhà báo",
      "Biên tập viên nội dung",
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 80,
              backgroundColor: Colors.white,
              elevation: 0.0,
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
                  const SizedBox(height: 20),
                  searchBarWidget(
                      controller: TextEditingController(), autofocus: false)
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: jobs.length,
                (context, index) {
                  final job = jobs[index];
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(job),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
