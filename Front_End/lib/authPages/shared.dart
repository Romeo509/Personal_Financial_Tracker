import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Shared {
  static String loginSharedPreferences = "LOGGEDINKEYS";

  static FutureOr<bool> saveLoginSharedPreference(isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(Shared.loginSharedPreferences, isLogin);
  }

  static FutureOr getUserSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(Shared.loginSharedPreferences);
  }
}
