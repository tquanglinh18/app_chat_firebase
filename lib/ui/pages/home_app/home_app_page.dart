import 'package:flutter/material.dart';
import 'package:flutter_base/ui/pages/home_app/contact/contact_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../common/app_colors.dart';
import '../../../common/app_images.dart';
import 'chats/chats_page.dart';
import 'home_app_cubit.dart';
import 'more/more_page.dart';

List<String> listUrlImage = [AppImages.icPerson, AppImages.icChat, AppImages.icMore];
List<String> listTitle = ["Contacts", "Chats", "More"];

class HomeAppPage extends StatefulWidget {
  final String? name;
  final String? phoneNumber;
  final String? urlAvatar;

  const HomeAppPage({
    Key? key,
    this.name,
    this.phoneNumber,
    this.urlAvatar,
  }) : super(key: key);

  @override
  State<HomeAppPage> createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  late HomeAppCubit _cubit;

  @override
  void initState() {
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
                    return const ChatsPage();
                  case 2:
                    return const MorePage();
                  default:
                    return const ContactPage();
                }
              },
            ),
          ),
          _bottomNavigator,
        ],
      ),
    );
  }

  Widget get _bottomNavigator {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0,
      child: BlocBuilder<HomeAppCubit, HomeAppState>(
        bloc: _cubit,
        buildWhen: (pre, cur) => pre.selectedIndex != cur.selectedIndex,
        builder: (context, state) {
          return SizedBox(
            height: 83 + MediaQuery.of(context).padding.bottom,
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
                            urlImage: listUrlImage[index],
                            title: listTitle[index],
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
      ),
    );
  }

  Widget itemBottomNavigatorIsSelected({
    required String urlImage,
    required String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const Text(
          "•",
          style: TextStyle(fontSize: 30),
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
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
