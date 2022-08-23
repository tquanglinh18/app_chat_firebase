import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_colors.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/common/app_text_styles.dart';
import 'package:flutter_base/ui/pages/contact/contact_cubit.dart';
import 'package:flutter_base/ui/widgets/appbar/app_bar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> listUrlImage = [AppImages.icPerson, AppImages.icChat, AppImages.icMenu];
List<String> listTitle = ["Contacts", "Chats", "More"];

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late ContactCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = ContactCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AppBarWidget(
              title: 'CONTACTS',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _search(),
            ),
            Expanded(
              child: _contacts(),
            ),
            bottomNavigator(),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigator() {
    return BlocBuilder<ContactCubit, ContactState>(
      bloc: _cubit,
      buildWhen: (pre, cur) => pre.selectedIndex != cur.selectedIndex,
      builder: (context, state) {
        return SizedBox(
          height: 83,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 3,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _cubit.onItemTapped(index);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: state.selectedIndex == index
                      ? itemBottomNavigatorIsSelected(listUrlImage[index], listTitle[index])
                      : itemBottomNavigatorIsNotSelected(listUrlImage[index], listTitle[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget itemBottomNavigatorIsSelected(String urlImage, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const Text(
          "•",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ],
    );
  }

  Widget itemBottomNavigatorIsNotSelected(String urlImage, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Image.asset(
            urlImage,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      height: 36,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.titleColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search,
            color: AppColors.hintTextColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: AppTextStyle.greyS14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.hintTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contacts() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Container(
            height: 68,
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
                            fit: BoxFit.cover,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
            height: 1,
            width: MediaQuery.of(context).size.width - 24 * 2,
            color: AppColors.greyBG,
          );
        },
        itemCount: 10,
      ),
    );
  }

  Widget _chat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
        Container(
          height: 1,
          color: AppColors.greyBG,
          margin: const EdgeInsets.symmetric(vertical: 16),
        ),
        _search(),
        Expanded(
          child: _userChat(),
        )
      ],
    );
  }

  Widget _userChat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
            height: 68,
            width: MediaQuery.of(context).size.width - 24 * 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.network(
                      'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/ab34c463-f9b8-4b0f-8591-38656d0e88f7/ddhkeiz-bc13a721-ecbf-4533-b793-49894664d8df.png/v1/fill/w_1280,h_1034,q_80,strp/sad_joey_by_gloriabomfim2019_ddhkeiz-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTAzNCIsInBhdGgiOiJcL2ZcL2FiMzRjNDYzLWY5YjgtNGIwZi04NTkxLTM4NjU2ZDBlODhmN1wvZGRoa2Vpei1iYzEzYTcyMS1lY2JmLTQ1MzMtYjc5My00OTg5NDY2NGQ4ZGYucG5nIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.YPq4aloEl8kE8fZIbIXUY6kDjHSUKg1osRwGpcURTA4',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "name",
                          style: AppTextStyle.blackS14.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Today",
                          style: AppTextStyle.greyS14.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Good morning, did you sleep well?",
                          style: AppTextStyle.greyS14.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                          alignment: Alignment.center,
                          height: 20,
                          width: 22,
                          decoration:
                              BoxDecoration(color: AppColors.messageColor, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "2",
                            style: AppTextStyle.black.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 1,
            width: MediaQuery.of(context).size.width - 24 * 2,
            color: AppColors.greyBG,
          );
        },
        itemCount: 10,
      ),
    );
  }
}
