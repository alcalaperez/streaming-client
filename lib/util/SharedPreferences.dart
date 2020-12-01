import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static Future<String> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("token");
  }

  static setToken(String token) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("token", token);
  }

  static Future<String> getUsername() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("username");
  }

  static setUsername(String username) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("username", username);
  }

  static Future<String> getPicUrl() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString("picUrl");
  }

  static setPicUrl(String username) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("picUrl", username);
  }
}