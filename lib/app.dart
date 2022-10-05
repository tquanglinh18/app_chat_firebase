import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/configs/app_configs.dart';
import 'package:flutter_base/repositories/chat_repository.dart';
import 'package:flutter_base/router/route_config.dart';
import 'package:flutter_base/ui/pages/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'blocs/app_cubit.dart';
import 'blocs/setting/app_setting_cubit.dart';
import 'common/app_colors.dart';
import 'common/app_themes.dart';
import 'generated/l10n.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
@override
  void initState() {
    // TODO: implement initState
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //Setup PortraitUp only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiRepositoryProvider(
      providers:  [
        RepositoryProvider<ChatRepository>(create: (context) {
          return ChatRepositoryImpl();
        }),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppCubit>(create: (context) {
            return AppCubit(
            );
          }),
          BlocProvider<AppSettingCubit>(create: (context) {
            return AppSettingCubit();
          }),
        ],
        child: BlocBuilder<AppSettingCubit, AppSettingState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _hideKeyboard(context);
              },
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppConfigs.appName,
                home: const SplashPage(),
                theme: AppThemes(
                  isDarkMode: false,
                  primaryColor: state.primaryColor,
                  secondaryColor: AppColors.textBlack,
                ).theme,
                darkTheme: AppThemes(
                  isDarkMode: true,
                  primaryColor: state.primaryColor,
                  secondaryColor: AppColors.backgroundLight,
                ).theme,
                themeMode: state.themeMode,
                initialRoute: RouteConfig.splash,
                getPages: RouteConfig.getPages,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  S.delegate,
                ],
                locale: state.locale,
                supportedLocales: S.delegate.supportedLocales,
              ),
            );
          },
        ),
      ),
    );
  }

  void _hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
