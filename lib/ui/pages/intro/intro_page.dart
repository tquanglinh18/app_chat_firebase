import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/input_number/input_number_page.dart';

import '../../../common/app_images.dart';
import '../../commons/app_buttons.dart';

class IntroAppPage extends StatelessWidget {
  const IntroAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 135,
              ),
              Image.asset(AppImages.icIntroApp),
              const SizedBox(height: 50),
              Text(
                'Connect easily with your family and friends over countries',
                textAlign: TextAlign.center,
                style: AppTextStyle.blackS18.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 140),
              Text(
                'Terms & Privacy Policy',
                style: AppTextStyle.blackS14.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              AppButtons(
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InputNumberPage())),
                title: "Start Messaging",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
