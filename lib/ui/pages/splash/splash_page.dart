import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/database/share_preferences_helper.dart';
import '../home/home_page.dart';
import '../intro/intro_page.dart';
import '../profile/profile_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SplashChildPage();
  }
}

class SplashChildPage extends StatefulWidget {
  const SplashChildPage({Key? key}) : super(key: key);

  @override
  State<SplashChildPage> createState() => _SplashChildPageState();
}

class _SplashChildPageState extends State<SplashChildPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferencesHelper.getUidFireBaseKey().then(
      (value) {
        if (value.isNotEmpty) {
          SharedPreferencesHelper.getNameUserLoginKey().then(
            (value) {
              if (value.isNotEmpty) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                    settings: const RouteSettings(name: "home"),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(
                      colorIcon: Colors.transparent,
                    ),
                    settings: const RouteSettings(name: "profile"),
                  ),
                  (route) => false,
                );
              }
            },
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const IntroAppPage(),
              settings: const RouteSettings(name: "intro"),
            ),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                AppImages.icLogoTransparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
