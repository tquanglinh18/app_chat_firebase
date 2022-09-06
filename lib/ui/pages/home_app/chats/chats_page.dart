import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/home_app/chats/chats_cubit.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/custom_app_bar.dart';
import '../../../commons/custom_progress_hud.dart';
import '../../../commons/flus_bar.dart';
import '../../../commons/my_dialog.dart';
import '../../../commons/search_bar.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  TextEditingController controller = TextEditingController(text: "");
  late ChatsCubit _cubit;
  late final CustomProgressHUD _customProgressHUD;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ChatsCubit();
    _cubit.getDataLocal();
    _cubit.getStory();
    _cubit.getListUser();
    FirebaseFirestore.instance.collection('story').snapshots().listen(
      (event) {
        _cubit.realTimeFireBase();
      },
      onError: (error) => logger.d("Realtime $error"),
    );
    _customProgressHUD = MyDialog.buildProgressDialog(
      loading: true,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBarCustom(
                title: "Chats",
                icCount: 2,
                image: const [AppImages.icNewMessage, AppImages.icMarkAsRead],
                onTap: () {
                  DxFlushBar.showFlushBar(context, type: FlushBarType.WARNING, title: "Tính năng đang được cập nhật !");
                },
              ),
              _story(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: BlocBuilder<ChatsCubit, ChatsState>(
                  bloc: _cubit,
                  buildWhen: (pre, cur) => pre.searchText != cur.searchText,
                  builder: (context, state) {
                    return SearchBar(
                      onChanged: (value) => _cubit.onSearchTextChanged(value),
                      controller: controller,
                      onClose: () {
                        controller.text = '';
                        _cubit.getListUser();
                      },
                      onSubmit: (text) {
                        _cubit.searchUser(text);
                      },
                      isClose: state.searchText!.isEmpty ? false : true,
                    );
                  },
                ),
              ),
              Expanded(
                child: _userChat(),
              )
            ],
          ),
          _customProgressHUD,
        ],
      ),
    );
  }

  Widget _story() {
    return SizedBox(
      height: 112,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          BlocListener<ChatsCubit, ChatsState>(
            bloc: _cubit,
            listenWhen: (pre, cur) => pre.loadStatusUpStory != cur.loadStatusUpStory,
            listener: (context, state) {
              // TODO: implement listener
              if (state.loadStatusUpStory == LoadStatus.failure) {
                DxFlushBar.showFlushBar(context, title: "Đã xảy ra lỗi!", type: FlushBarType.ERROR);
              }
            },
            child: InkWell(
              onTap: () {
                _getFromGallery();
                FocusScope.of(context).unfocus();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(24, 16, 8, 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: Image.asset(
                        AppImages.icStory,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("Your Story"),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatsCubit, ChatsState>(
              bloc: _cubit,
              buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus || pre.listStory != cur.listStory,
              builder: (context, state) {
                return ListView.builder(
                    itemCount: state.listStory.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xffD2D5F9),
                                        Color(0xff2C37E1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 2,
                                      color: AppColors.backgroundLight,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(state.listStory[index].listImagePath?.last ?? ''),
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.info_outline,
                                          color: AppColors.border,
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.uid == state.listStory[index].uid
                                  ? "Your Story"
                                  : state.listStory[index].name ?? "",
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _userChat() {
    return BlocConsumer<ChatsCubit, ChatsState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.loadStatusGetUser != cur.loadStatusGetUser,
      listener: (context, state) {
        if (state.loadStatusGetUser != LoadStatus.loading) {
          _customProgressHUD.progress.dismiss();
        }
      },
      buildWhen: (pre, cur) => pre.listUser != cur.listUser || pre.loadStatusGetUser != cur.loadStatusGetUser,
      builder: (context, state) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(4),
              height: 56,
              width: MediaQuery.of(context).size.width - 24 * 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: Image.file(
                        File(state.listUser[index].avatar ?? ""),
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      state.listUser[index].name ?? "",
                      style: AppTextStyle.blackS14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
          itemCount: state.listUser.length,
        );
      },
    );
  }

  _getFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    _cubit.setImage(image.path);
  }
}
