import 'package:flutter/material.dart';

import '../../../../common/app_colors.dart';
import '../../../../common/app_images.dart';
import '../../../../common/app_text_styles.dart';
import '../../../commons/custom_app_bar.dart';
import '../../../commons/flus_bar.dart';
import '../../../commons/search_bar.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          SearchBar(),
          Expanded(
            child: _userChat(),
            // child: RefreshIndicator(
            //   onRefresh: () {
            //     return _cubit.onItemTapped(0);
            //   },
            //   child: _userChat(),
            // ),
          )
        ],
      ),
    );
  }

  Widget _story() {
    return Row(
      children: [
        Container(
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
        Container(
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
                      child: Image.network(
                        "https://media.wired.co.uk/photos/60c8730fa81eb7f50b44037e/3:2/w_3329,h_2219,c_limit/1521-WIRED-Cat.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Your Story"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userChat() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      child: ListView.separated(
        padding: EdgeInsets.zero,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name",
                        style: AppTextStyle.blackS14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Good morning, did you sleep well?",
                        style: AppTextStyle.greyS14.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Today",
                      style: AppTextStyle.greyS14.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 20,
                      width: 22,
                      decoration: BoxDecoration(
                        color: AppColors.messageColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "2",
                        style: AppTextStyle.black.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
