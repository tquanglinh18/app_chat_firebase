import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/app_buttons.dart';
import 'package:flutter_base/ui/pages/home_app/home_app_page.dart';
import 'package:flutter_base/ui/pages/profile_user/profile_user_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/app_colors.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({Key? key}) : super(key: key);

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  late ProfileUserCubit _cubit;
  File? _image;
  bool _isHide = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ProfileUserCubit();
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
                      onChanged: (value) {
                        _cubit.firstNameChanged(value);
                      },
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
                      onChanged: (value) {
                        _cubit.lastNameChanged(value);
                      },
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
                  BlocConsumer<ProfileUserCubit, ProfileUserState>(
                    bloc: _cubit,
                    buildWhen: (pre, cur) => pre.firstName != cur.firstName,
                    listenWhen: (pre, cur) => pre.firstName != cur.firstName,
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: AppButtons(
                          buttonType: state.firstName != '' ? ButtonType.ACTIVE : ButtonType.IN_ACTIVE,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomeAppPage(),
                              ),
                            );
                          },
                          title: "Save",
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            _choseOptionImage(),
          ],
        ),
      ),
    );
  }

  Widget avatar() {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        children: [
          _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Image.asset(AppImages.icAvatarDefault),
          Positioned(
            right: 5,
            bottom: 1,
            child: InkWell(
              onTap: () => setState(() {
                _isHide = !_isHide;
              }),
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
  }

  Widget _choseOptionImage() {
    return Visibility(
      visible: _isHide,
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.buttonBGWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
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
                    Text('Pick Image from Camera'),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: AppColors.backgroundLight,
            ),
            InkWell(
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
                    Text('Pick image from gallery'),
                  ],
                ),
              ),
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
    final imageGallery = File(image.path);
    setState(
      () {
        _image = imageGallery;
      },
    );
  }

  _getFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    final imageCamera = File(image.path);
    setState(
      () {
        _image = imageCamera;
      },
    );
  }
}
