import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/logger.dart';
import '../../../commons/custom_app_bar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppBarCustom(
            title: "Contacts",
            icCount: 1,
            image: const [AppImages.icAddContact],
            onTap: () {
              DxFlushBar.showFlushBar(context, type: FlushBarType.WARNING, title: "Tính năng đang được cập nhật !");
            },
          ),
          BlocBuilder<ContactCubit, ContactState>(
            bloc: _cubit,
            buildWhen: (pre, cur) => pre.searchText != cur.searchText,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SearchBar(
                  onChanged: (value) => _cubit.onSearchTextChanged(value),
                  controller: controller,
                  onClose: () {
                    controller.text = "";
                  },
                  isClose: state.searchText != "" ? true : false,
                ),
              );
            },
          ),
          Expanded(
            child: _contacts(),
          ),
        ],
      ),
    );
  }

  Widget _contacts() {
    return BlocBuilder<ContactCubit, ContactState>(
      bloc: _cubit,
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.listConversion!.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      idConversion: state.listConversion![index].idConversion ?? "",
                      nameConversion: state.listConversion![index].nameConversion ?? '',
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 48,
                              width: 48,
                              child: Image.network(
                                "${state.listConversion![index].avatarConversion}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.textWhite,
                                width: 2,
                              ),
                              color: AppColors.isOnlineColor,
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${state.listConversion![index].nameConversion}",
                      style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(top: 15.5, bottom: 12.5),
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: AppColors.greyBG,
            );
          },
        );
      },
    );
  }
}
