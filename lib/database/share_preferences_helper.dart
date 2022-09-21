import 'package:flutter_base/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _introKey = '_introKey';

  static const _authKey = '_authKey';

  static const _uidFireBase = '_uidFireBase';

  static const _nameUserLogin = '_nameUserLogin';

  static const _phoneUserLogin = '_phoneUserLogin';

  static Future<String> getPhoneUserLoginKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_phoneUserLogin) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set authKey
  static void setPhoneUserLoginKey(String phoneUserLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneUserLogin, phoneUserLogin);
  }

  static void removePhoneUserLoginKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneUserLogin);
  }

  static Future<String> getNameUserLoginKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_nameUserLogin) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set nameUserLogin
  static void setNameUserLoginKey(String nameUserLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameUserLogin, nameUserLogin);
  }

  static void removeNameUserLoginKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameUserLogin);
  }

  //Get authKey
  static Future<String> getUidFireBaseKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_uidFireBase) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set authKey
  static void setUidFireBaseKey(String uidFireBase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidFireBase, uidFireBase);
  }

  static void removeUidFireBaseKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidFireBase);
  }

  //Get authKey
  static Future<String> getApiTokenKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authKey) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set authKey
  static void setApiTokenKey(String apiTokenKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, apiTokenKey);
  }

  static void removeApiTokenKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }

  //Get intro
  static Future<bool> isSeenIntro() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_introKey) ?? false;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  //Set intro
  static void setSeenIntro({isSeen = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introKey, isSeen ?? true);
  }
}
