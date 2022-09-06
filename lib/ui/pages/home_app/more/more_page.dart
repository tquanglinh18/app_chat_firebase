import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/home_app/more/more_cubit.dart';
import 'package:flutter_base/ui/pages/home_app/more/type_setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/custom_app_bar.dart';
import '../../setting/setting_page.dart';

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

class MorePage extends StatefulWidget {
  const MorePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late MoreCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = MoreCubit();
    _cubit.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoreCubit, MoreState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
        builder: (context, state) {
          return Column(
            children: [
              AppBarCustom(title: "More"),
              _infoUser(name: state.name, phoneNumber: state.phoneNumber, urlImage: state.avatar),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: _itemMore(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoUser({String? urlImage, String? name, String? phoneNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 50,
              width: 50,
              child: (urlImage ?? "").isNotEmpty
                  ? Image.file(
                      File(urlImage!),
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 1,
                              color: AppColors.greyBG,
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: AppColors.border,
                          ),
                        );
                      },
                fit: BoxFit.cover,
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage(AppImages.icAvatarDefault),
                    ),
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
          onTap: () {
            Get.to(() => const SettingPage());
          },
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
