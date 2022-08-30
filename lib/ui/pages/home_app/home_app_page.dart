import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/home_app/contact/contact_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_images.dart';
import 'chats/chats_page.dart';
import 'home_app_cubit.dart';
import 'more/more_page.dart';

List<String> listUrlImage = [AppImages.icPerson, AppImages.icChat, AppImages.icMore];
List<String> listTitle = ["Contacts", "Chats", "More"];

class HomeAppPage extends StatefulWidget {
  const HomeAppPage({Key? key}) : super(key: key);

  @override
  State<HomeAppPage> createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  late HomeAppCubit _cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = HomeAppCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeAppCubit, HomeAppState>(
              bloc: _cubit,
              builder: (context, state) {
                switch (state.selectedIndex) {
                  case 0:
                    return const ContactPage();
                  case 1:
                    return ChatsPage();
                  case 2:
                    return const MorePage();
                  default:
                    return const ContactPage();
                }
              },
            ),
          ),
          _bottomNavigator(),
        ],
      ),
    );
  }

  Widget _bottomNavigator() {
    return BlocBuilder<HomeAppCubit, HomeAppState>(
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
                      ? itemBottomNavigatorIsSelected(
                          listUrlImage[index],
                          listTitle[index],
                        )
                      : itemBottomNavigatorIsNotSelected(
                          listUrlImage[index],
                          listTitle[index],
                        ),
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
}
