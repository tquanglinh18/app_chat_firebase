import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_text_styles.dart';

import '../../common/app_colors.dart';

class AppButtons extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const AppButtons({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.btnColor,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            title!,
            style: AppTextStyle.whiteS16.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
