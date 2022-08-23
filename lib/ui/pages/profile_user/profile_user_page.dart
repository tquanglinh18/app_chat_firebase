import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/app_buttons.dart';
import 'package:flutter_base/ui/pages/contact/contact_page.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_base/ui/widgets/images/app_circle_avatar.dart';

import '../../../common/app_colors.dart';
import '../../widgets/images/avatar.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({Key? key}) : super(key: key);

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarWidget(
            onBackPressed: Navigator.of(context).pop,
            title: "Your Profile",
          ),
          const SizedBox(height: 46),
          avatar(),
          const SizedBox(height: 31),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            height: 36,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.greyBG),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "First Name (Required)",
                hintStyle: AppTextStyle.greyS14.copyWith(
                  color: AppColors.hintTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            height: 36,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.greyBG),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Last Name (Optional)",
                hintStyle: AppTextStyle.greyS14.copyWith(
                  color: AppColors.hintTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: AppButtons(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactPage()));
              },
              title: "Save",
            ),
          ),
        ],
      ),
    );
  }

  Widget avatar() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          Image.asset(
            AppImages.icAvatarDefault,
          ),
          Positioned(
            right: 5,
            bottom: 1,
            child: Image.asset(AppImages.icAdd),
          ),
        ],
      ),
    );
  }
}
