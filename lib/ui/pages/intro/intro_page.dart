import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/input_number/input_number_page.dart';

import '../../../common/app_images.dart';
import '../../../generated/l10n.dart';
import '../../commons/app_buttons.dart';

class IntroAppPage extends StatelessWidget {
  const IntroAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 135,
                    ),
                    Image.asset(AppImages.icIntroApp),
                    const SizedBox(height: 43),
                    Text(
                      S.of(context).intro_content,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.blackS18.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const SizedBox(height: 130),
                    Text(
                      S.of(context).policy,
                      style: AppTextStyle.blackS14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _btnStart(
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const InputNumberPage(),
              ),
            ),
            MediaQuery.of(context).size.width - 40,
            MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }

  Widget _btnStart(
    Function() onTap,
    double width,
    double height,
  ) {
    return Builder(
      builder: (context) {
        return Positioned(
          top: height - 100,
          left: 20,
          child: AppButtons(
            buttonType: ButtonType.ACTIVE,
            onTap: onTap,
            title: S.of(context).start_message,
            width: width,
          ),
        );
      }
    );
  }
}
