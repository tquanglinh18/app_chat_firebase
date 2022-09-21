import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/app_buttons.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/pages/home_app/home_app_page.dart';
import 'package:flutter_base/ui/pages/profile_user/profile_user_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_colors.dart';
import '../../../database/share_preferences_helper.dart';

class ProfileUserPage extends StatefulWidget {
  final Color colorIcon;

  const ProfileUserPage({
    Key? key,
    this.colorIcon = Colors.black,
  }) : super(key: key);

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  late ProfileUserCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ProfileUserCubit();
    _cubit.getListUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  _buildAppBar,
                  const SizedBox(height: 46),
                  _avtUserLogin(context),
                  const SizedBox(height: 31),
                  _firstNameField,
                  const SizedBox(height: 12),
                  _lastNameField,
                  const SizedBox(height: 70),
                  _saveBtn,
                ],
              ),
            ),
            _choseOptionImage,
          ],
        ),
      ),
    );
  }

  Widget get _buildAppBar {
    return AppBarWidget(
      onBackPressed: Navigator.of(context).pop,
      title: "Your Profile",
      colorIcon: Theme.of(context).iconTheme.color!,
    );
  }

  Widget get _saveBtn {
    return BlocConsumer<ProfileUserCubit, ProfileUserState>(
      bloc: _cubit,
      buildWhen: (pre, cur) =>
          pre.firstName != cur.firstName || pre.lastName != cur.lastName || pre.loadStatus != cur.loadStatus,
      listenWhen: (pre, cur) => pre.loadStatus != cur.loadStatus,
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const HomeAppPage(),
              settings: const RouteSettings(name: "home"),
            ),
            (route) => false,
          );
        } else if (state.loadStatus == LoadStatus.failure) {
          DxFlushBar.showFlushBar(
            context,
            type: FlushBarType.ERROR,
            title: "Không thể lưu",
          );
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: AppButtons(
            isLoading: state.loadStatus == LoadStatus.loading,
            buttonType: state.firstName != '' ? ButtonType.ACTIVE : ButtonType.IN_ACTIVE,
            onTap: () async {
              _cubit.uploadUser(
                '${state.firstName} ${state.lastName}',
                await SharedPreferencesHelper.getPhoneUserLoginKey(),
              );
              FocusScope.of(context).unfocus();
            },
            title: "Save",
          ),
        );
      },
    );
  }

  Widget get _firstNameField {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 36,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.greyBG),
      child: TextFormField(
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyle.blackS14,
        onChanged: (value) {
          _cubit.firstNameChanged(value);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          border: InputBorder.none,
          hintText: "First Name (Required)",
          hintStyle: AppTextStyle.greyS14.copyWith(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget get _lastNameField {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      height: 36,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: AppColors.greyBG),
      child: TextFormField(
        style: AppTextStyle.blackS14,
        onChanged: (value) {
          _cubit.lastNameChanged(value);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          border: InputBorder.none,
          hintText: "Last Name (Optional)",
          hintStyle: AppTextStyle.greyS14.copyWith(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _avtUserLogin(BuildContext contextKey) {
    return BlocConsumer<ProfileUserCubit, ProfileUserState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.image != cur.image,
      listener: (context, state) {
        if (state.image.isNotEmpty) {
          _cubit.isHide();
        }
      },
      buildWhen: (pre, cur) => pre.image != cur.image,
      builder: (context, state) {
        return SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              state.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: ImgFile(
                          urlFile: state.image,
                        ),
                      ),
                    )
                  : Image.asset(AppImages.icAvatarDefault),
              Positioned(
                right: 5,
                bottom: 1,
                child: InkWell(
                  onTap: () {
                    _cubit.isHide();
                    FocusScope.of(contextKey).unfocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.backgroundLight,
                    ),
                    child: Image.asset(
                      AppImages.icAdd,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _choseOptionImage {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.isHide != cur.isHide,
      builder: (context, state) {
        return Visibility(
          visible: state.isHide,
          child: Container(
            height: 150 + MediaQuery.of(context).padding.bottom,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.buttonBGWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _optionCamera,
                Container(
                  height: 1,
                  color: AppColors.backgroundLight,
                ),
                _optionGallery,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget get _optionCamera {
    return InkWell(
      onTap: () {
        _getFromCamera();
      },
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width - 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.camera_alt_outlined,
              color: AppColors.textBlack,
            ),
            SizedBox(width: 15),
            Text(
              'Pick Image from Camera',
              style: AppTextStyle.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _optionGallery {
    return InkWell(
      onTap: () {
        _getFromGallery();
      },
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width - 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.camera,
              color: AppColors.textBlack,
            ),
            SizedBox(width: 15),
            Text(
              'Pick image from gallery',
              style: AppTextStyle.black,
            ),
          ],
        ),
      ),
    );
  }

  _getFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    _cubit.setImage(image.path);
  }

  _getFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    _cubit.setImage(image.path);
  }
}
