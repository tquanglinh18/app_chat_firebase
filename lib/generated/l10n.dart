// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settings_themeMode {
    return Intl.message(
      'Theme',
      name: 'settings_themeMode',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get settings_themeModeSystem {
    return Intl.message(
      'System',
      name: 'settings_themeModeSystem',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settings_themeModeLight {
    return Intl.message(
      'Light',
      name: 'settings_themeModeLight',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settings_themeModeDark {
    return Intl.message(
      'Dark',
      name: 'settings_themeModeDark',
      desc: '',
      args: [],
    );
  }

  /// `Tiếng việt`
  String get settings_languageVietnamese {
    return Intl.message(
      'Tiếng việt',
      name: 'settings_languageVietnamese',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get settings_languageEnglish {
    return Intl.message(
      'English',
      name: 'settings_languageEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settings_language {
    return Intl.message(
      'Language',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get button_signIn {
    return Intl.message(
      'Sign In',
      name: 'button_signIn',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
