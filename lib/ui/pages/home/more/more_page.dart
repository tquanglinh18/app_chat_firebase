import 'package:flutter/material.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/pages/home/more/type_setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/avatar.dart';
import '../../../commons/custom_app_bar.dart';
import '../../setting/setting_page.dart';
import 'more_cubit.dart';

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
              _infoUser(
                name: state.name,
                phoneNumber: state.phoneNumber,
                urlImage: state.avatar,
              ),
              Expanded(
                child: _itemMore,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoUser({
    String? urlImage,
    String? name,
    String? phoneNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: (urlImage ?? "").isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ImgNetwork(
                       urlFile: urlImage ?? "",
                    ),
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage(AppImages.icAvatarDefault),
                  ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameUserLogin(
                  name!,
                ),
                _phoneNumberUserLogin(phoneNumber!),
              ],
            ),
          ),
          Image.asset(
            AppImages.icNext,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }

  Widget _nameUserLogin(String name) {
    return Text(
      name,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  Widget _phoneNumberUserLogin(String phoneNumber) {
    return Text(
      phoneNumber,
      style: AppTextStyle.greyS12.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 2,
      ),
    );
  }

  Widget get _itemMore {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 2) {
                Get.to(() => const SettingPage());
              }
            },
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  _iconMoreOption(
                    pathIcon: listType[index].pathIcon,
                    color: Theme.of(context).iconTheme.color!,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _titleMoreOption(
                      title: listType[index].title,
                      style: Theme.of(context).textTheme.bodyText1!,
                    ),
                  ),
                  Image.asset(
                    AppImages.icNext,
                    color: Theme.of(context).iconTheme.color!,
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
      ),
    );
  }

  Widget _titleMoreOption({
    required String title,
    required TextStyle style,
  }) {
    return Text(
      title,
      style: style,
    );
  }

  Widget _iconMoreOption({
    required String pathIcon,
    Color? color,
  }) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Image.asset(
        pathIcon,
        fit: BoxFit.contain,
        height: 3,
        color: color,
      ),
    );
  }
}
