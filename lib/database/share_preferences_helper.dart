import 'package:flutter_base/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _uidFireBase = '_uidFireBase';

  static const _nameUserLogin = '_nameUserLogin';

  static const _phoneUserLogin = '_phoneUserLogin';

  // Get phoneNumberKey
  static Future<String> getPhoneUserLoginKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_phoneUserLogin) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set phoneNumberKey
  static void setPhoneUserLoginKey(String phoneUserLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneUserLogin, phoneUserLogin);
  }

  //Remove phoneNumberKey
  static void removePhoneUserLoginKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneUserLogin);
  }

  //Get nameUserLogin
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

  // Remove nameUserLogin
  static void removeNameUserLoginKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameUserLogin);
  }

  //Get uidFireBase
  static Future<String> getUidFireBaseKey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_uidFireBase) ?? "";
    } catch (e) {
      logger.e(e);
      return "";
    }
  }

  //Set uidFireBase
  static void setUidFireBaseKey(String uidFireBase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidFireBase, uidFireBase);
  }

  // Remove uidFireBase
  static void removeUidFireBaseKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidFireBase);
  }
}
