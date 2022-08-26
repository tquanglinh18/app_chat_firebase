import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/home_app/more/type_setting.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/custom_app_bar.dart';

List<SettingType> listType = [
  SettingType.ACCOUNT,
  SettingType.CHAT,
  SettingType.APPEREANCE,
  SettingType.NOTIFICATION,
  SettingType.PRIVACY,
  SettingType.DATA_USAGE,
  SettingType.HELP,
  SettingType.INVITE_YOUR_FRIENDS,
];

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarCustom(title: "More"),
          _infoUser(name: "Almayra Zamzamy", phoneNumber: "+62 1309 - 1710 - 1920"),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _itemMore(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoUser({String? urlImage, String? name, String? phoneNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: CircleAvatar(
              backgroundImage: AssetImage(urlImage ?? AppImages.icAvatarDefault),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "",
                  style: AppTextStyle.blackS14.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  phoneNumber ?? "",
                  style: AppTextStyle.greyS12.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.hintTextColor,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(AppImages.icNext),
        ],
      ),
    );
  }

  Widget _itemMore({VoidCallback? onTap}) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    listType[index].pathIcon,
                    fit: BoxFit.contain,
                    height: 3,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    listType[index].title,
                    style: AppTextStyle.blackS14.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Image.asset(
                  AppImages.icNext,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: listType.length,
    );
  }
}
