import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Sử dụng spaceBetween
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset("assets/images/splash/intro.svg"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  introduction(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    AppConstants.introContent,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff524B6B)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            // Nút sẽ luôn nằm ở cuối màn hình
            arrowButton(context),
          ],
        ),
      ),
    );
  }

  Widget introduction() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        children: [
          TextSpan(text: "Find Your\n"),
          TextSpan(
            text: "Dream Job\n",
            style: TextStyle(color: AppColors.primary),
          ),
          TextSpan(text: "Here!"),
        ],
      ),
    );
  }

  Widget arrowButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () => context.go("/${RouteNames.login.name}"),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
