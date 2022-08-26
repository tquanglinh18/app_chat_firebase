// ignore_for_file: constant_identifier_names

import 'package:flutter_base/common/app_images.dart';

enum SettingType {
  ACCOUNT,
  CHAT,
  APPEREANCE,
  NOTIFICATION,
  PRIVACY,
  DATA_USAGE,
  HELP,
  INVITE_YOUR_FRIENDS,
}

extension SettingTypeExtension on SettingType {
  String get title {
    switch (this) {
      case SettingType.ACCOUNT:
        return 'Acount';
      case SettingType.CHAT:
        return 'Chat';
      case SettingType.APPEREANCE:
        return 'Appereance';
      case SettingType.NOTIFICATION:
        return 'Notification';
      case SettingType.PRIVACY:
        return 'Privacy';
      case SettingType.DATA_USAGE:
        return 'Data Usage';
      case SettingType.HELP:
        return 'Help';
      case SettingType.INVITE_YOUR_FRIENDS:
        return 'Invite Your Friends';
    }
  }

  String get pathIcon {
    switch (this) {
      case SettingType.ACCOUNT:
        return AppImages.icAccount;
      case SettingType.CHAT:
        return AppImages.icChats;
      case SettingType.APPEREANCE:
        return AppImages.icAppereance;
      case SettingType.NOTIFICATION:
        return AppImages.icNotification;
      case SettingType.PRIVACY:
        return AppImages.icPrivacy;
      case SettingType.DATA_USAGE:
        return AppImages.icDataUsage;
      case SettingType.HELP:
        return AppImages.icHelp;
      case SettingType.INVITE_YOUR_FRIENDS:
        return AppImages.icInviteYourFriends;
    }
  }

}
