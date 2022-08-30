import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/commons/flus_bar.dart';
import 'package:flutter_base/ui/commons/search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late FirebaseFirestore db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ContactCubit();
    db = FirebaseFirestore.instance;
    getData();
  }

  getData() async {
    await db.collection("user").get().then(
      (event) {
        for (var doc in event.docs) {
          print("${doc.id} => ${doc.data()}");
        }
      },
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
    return InkWell(
      onTap: () {
        getData();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ChatPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(4),
              height: 56,
              width: MediaQuery.of(context).size.width - 24 * 2,
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
                              'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/ab34c463-f9b8-4b0f-8591-38656d0e88f7/ddhkeiz-bc13a721-ecbf-4533-b793-49894664d8df.png/v1/fill/w_1280,h_1034,q_80,strp/sad_joey_by_gloriabomfim2019_ddhkeiz-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAzNCIsInBhdGgiOiJcL2ZcL2FiMzRjNDYzLWY5YjgtNGIwZi04NTkxLTM4NjU2ZDBlODhmN1wvZGRoa2Vpei1iYzEzYTcyMS1lY2JmLTQ1MzMtYjc5My00OTg5NDY2NGQ4ZGYucG5nIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.YPq4aloEl8kE8fZIbIXUY6kDjHSUKg1osRwGpcURTA4',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.textWhite, width: 2),
                            color: AppColors.isOnlineColor,
                            shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "name",
                        style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Online",
                        style: AppTextStyle.greyS14.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ],
                  ),
                ],
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
          itemCount: 10,
        ),
      ),
    );
  }
}
