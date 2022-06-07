import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String UserLoggedInKey = "ISLOGGEDIN";
  static String UserNameKey = "USERNAMEKEY";
  static String UserEmailKey = "USEREMAILKEY";

  static Future<bool> SaveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(UserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> SaveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(UserNameKey, userName);
  }

  static Future<bool> SaveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(UserEmailKey, userEmail);
  }

  static Future<bool?> GetUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(UserLoggedInKey);
  }

  static Future<String?> GetUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(UserNameKey);
  }

  static Future<String?> GetUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(UserEmailKey);
  }
}
