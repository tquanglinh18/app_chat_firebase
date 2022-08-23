import 'package:flutter/material.dart';
import 'package:flutter_base/common/app_images.dart';
import 'package:flutter_base/repositories/auth_repository.dart';
import 'package:flutter_base/ui/pages/contact/contact_page.dart';
import 'package:flutter_base/ui/pages/profile_user/profile_user_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/user_repository.dart';
import '../intro/intro_page.dart';
import 'splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SplashCubit(
          authRepo: RepositoryProvider.of<AuthRepository>(context),
          userRepo: RepositoryProvider.of<UserRepository>(context),
        );
      },
      child: const SplashChildPage(),
    );
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
    context.read<SplashCubit>();
    init();
  }

  init() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const IntroAppPage(),
      ),
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
              child: Image.asset(AppImages.icLogoTransparent),
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
