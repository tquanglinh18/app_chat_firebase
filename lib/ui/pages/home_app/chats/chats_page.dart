import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/pages/home_app/chats/chats_cubit.dart';
import 'package:flutter_base/ui/pages/home_app/chats/view_story/view_story_page.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/custom_app_bar.dart';
import '../../../commons/custom_progress_hud.dart';
import '../../../commons/data_empty.dart';
import '../../../commons/flus_bar.dart';
import '../../../commons/img_file.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(theme.iconTheme.color!),
              _story,
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: AppColors.greyBG),
              ),
              _buildSearchBar,
              Expanded(
                child: _userChat(theme.textTheme.bodyText1),
              )
            ],
          ),
          _customProgressHUD,
        ],
      ),
    );
  }

  Widget get _buildSearchBar {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<ChatsCubit, ChatsState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.searchText != cur.searchText,
        builder: (context, state) {
          return SearchBar(
            hintText: "Tìm kiếm người dùng",
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
    );
  }

  Widget _buildAppBar(Color color) {
    return AppBarCustom(
      title: "Chats",
      icCount: 2,
      image: const [AppImages.icNewMessage, AppImages.icMarkAsRead],
      color: color,
      onTap: () {
        DxFlushBar.showFlushBar(
          context,
          type: FlushBarType.WARNING,
          title: "Tính năng đang được cập nhật !",
        );
      },
    );
  }

  Widget get _story {
    return SizedBox(
      height: 113,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _buildAddStory,
          Expanded(
            child: _buildListStory,
          ),
        ],
      ),
    );
  }

  Widget get _buildListStory {
    return BlocBuilder<ChatsCubit, ChatsState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.loadStatus != cur.loadStatus || pre.listStory != cur.listStory,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.listStory.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ViewStory(
                      urlImagePath: state.listStory[index].listImagePath ?? [],
                      urlAvatar: state.listUser.isNotEmpty
                          ? state.listUser
                                  .where((element) => element.uid == state.listStory[index].uid)
                                  .toList()
                                  .first
                                  .avatar ??
                              ""
                          : "",
                      name: state.listStory[index].name ?? '',
                    ),
                  ),
                );
              },
              child: _buildItemStr(
                state.listStory[index].listImagePath?.last ?? "",
                state.uid == state.listStory[index].uid ? "Your Story" : state.listStory[index].name ?? "",
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemStr(String urlFile, String nameUpStory) {
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
                  child: ImgFile(
                    urlFile: urlFile,
                    isBorderRadius: true,
                    isBorderSide: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            nameUpStory,
          ),
        ],
      ),
    );
  }

  Widget get _buildAddStory {
    return BlocListener<ChatsCubit, ChatsState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.loadStatusUpStory != cur.loadStatusUpStory,
      listener: (context, state) {
        if (state.loadStatusUpStory == LoadStatus.failure) {
          DxFlushBar.showFlushBar(
            context,
            title: "Đã xảy ra lỗi!",
            type: FlushBarType.ERROR,
          );
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
    );
  }

  Widget _userChat(TextStyle? style) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      bloc: _cubit,
      listenWhen: (pre, cur) => pre.loadStatusGetUser != cur.loadStatusGetUser,
      listener: (context, state) {
        if (state.loadStatusGetUser != LoadStatus.loading) {
          _customProgressHUD.progress.dismiss();
        } else {
          if (state.loadStatusGetUser == LoadStatus.loading) {
            _customProgressHUD.progress.show();
          }
        }
      },
      buildWhen: (pre, cur) => pre.loadStatusGetUser != cur.loadStatusGetUser,
      builder: (context, state) {
        if (state.loadStatusGetUser == LoadStatus.loading) {
          return const SizedBox();
        } else {
          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    height: 56,
                    width: MediaQuery.of(context).size.width - 24 * 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _avtUserChat(state.listUser[index].avatar ?? ""),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _nameUserChat(name: state.listUser[index].name ?? "", style: style!),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16);
                },
                itemCount: state.listUser.length,
              ),
              Visibility(
                visible: state.listUser.isEmpty,
                child: const DataEmpty(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _avtUserChat(String urlAvt) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 48,
        width: 48,
        child: ImgFile(urlFile: urlAvt),
      ),
    );
  }

  Widget _nameUserChat({
    required String name,
    required TextStyle style,
  }) {
    return Text(
      name,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
