import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/models/enums/load_status.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/img_file.dart';
import 'package:flutter_base/ui/commons/img_network.dart';
import 'package:flutter_base/ui/commons/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/logger.dart';
import '../../../commons/custom_app_bar.dart';
import '../../../commons/custom_progress_hud.dart';
import '../../../commons/data_empty.dart';
import '../../../commons/dialog_create_conversion/dialog_create_conversion.dart';
import '../../../commons/my_dialog.dart';
import '../../message/message_page.dart';
import 'contact_cubit.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController controller = TextEditingController(text: "");
  late ContactCubit _cubit;
  late final CustomProgressHUD _customProgressHUD;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ContactCubit();
    _cubit.initData();
    FirebaseFirestore.instance.collection('user').snapshots().listen(
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
          BlocConsumer<ContactCubit, ContactState>(
            listener: (context, state) {
              if (state.loadStatusAddConversion == LoadStatus.failure) {
                DxFlushBar.showFlushBar(
                  context,
                  type: FlushBarType.ERROR,
                  title: "Không thể tạo cuộc hội thoại",
                );
              }
            },
            bloc: _cubit,
            buildWhen: (pre, cur) => pre.searchText != cur.searchText,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAppBar,
                  _buildSearchBar(state.searchText ?? ''),
                  Expanded(
                    child: _contacts(),
                  ),
                ],
              );
            },
          ),
          _customProgressHUD,
        ],
      ),
    );
  }

  Widget get _buildAppBar {
    return AppBarCustom(
      title: "Contacts",
      icCount: 1,
      image: const [AppImages.icAddContact],
      onTap: () async {
        await showDialog(
          context: context,
          useRootNavigator: true,
          useSafeArea: false,
          builder: (BuildContext context) => const DialogCreateCobersion(),
        ).then(
          (value) {
            if (value != null) {
              _cubit.addConversion(value);
            }
          },
        );
      },
    );
  }

  Widget _buildSearchBar(String searchText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SearchBar(
        onChanged: (value) => _cubit.onSearchTextChanged(value),
        controller: controller,
        onClose: () {
          controller.text = "";
          _cubit.initData();
        },
        onSubmit: (value) {
          _cubit.listSearch(value);
        },
        isClose: searchText != "" ? true : false,
      ),
    );
  }

  Widget _contacts() {
    return BlocConsumer<ContactCubit, ContactState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state.loadStatusSearch == LoadStatus.success) {
          _customProgressHUD.progress.dismiss();
        } else {
          if (state.loadStatusSearch == LoadStatus.loading) {
            _customProgressHUD.progress.show();
          }
        }
      },
      listenWhen: (pre, cur) => pre.loadStatusSearch != cur.loadStatusSearch,
      builder: (context, state) {
        if (state.loadStatusSearch == LoadStatus.loading) {
          return const SizedBox();
        } else {
          return Stack(
            children: [
              ListView.separated(
                itemCount: state.listConversion.length,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            idConversion: state.listConversion[index].idConversion ?? "",
                            nameConversion: state.listConversion[index].nameConversion ?? '',
                          ),
                        ),
                      );
                    },
                    child: _buildListContact(
                      urlImageNetwok: state.listConversion[index].avatarConversion ?? '',
                      nameConversion: state.listConversion[index].nameConversion ?? '',
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return _separatorBuilder;
                },
              ),
              Visibility(
                visible: state.listConversion.isEmpty,
                child: const DataEmpty(),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildListContact({required String urlImageNetwok, required String nameConversion}) {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              _avtUser(urlImageNetwok),
              _isOnline,
            ],
          ),
          const SizedBox(width: 16),
          _nameConvertion(nameConversion),
        ],
      ),
    );
  }

  Widget _nameConvertion(String nameConversion) {
    return Text(
      nameConversion,
      style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _avtUser(String urlImageNetwok) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 48,
          width: 48,
          child: ImgFile(
            urlFile: urlImageNetwok,
          ),
        ),
      ),
    );
  }

  Widget get _isOnline {
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textWhite,
          width: 2,
        ),
        color: AppColors.isOnlineColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget get _separatorBuilder {
    return Container(
      margin: const EdgeInsets.only(top: 15.5, bottom: 12.5),
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: AppColors.greyBG,
    );
  }
}
