import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys

  static String UserLoggedInKey = "LOGGEDINKEY";
  static String UserNameKey = "USERNAMEKEY";
  static String UserEmailKey = "USEREMAILKEY";

  // saving the data to SF
  static Future<bool> SaveUSerLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(UserLoggedInKey, isUserLoggedIn);
  }


  static Future<bool> SaveUserNameSF(String UserName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(UserNameKey, UserName);
  }

  static Future<bool> SaveUserEmailSF(String UserEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(UserEmailKey, UserEmail);
  }

  // Getting the data from SF
  static Future<bool?> GetUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(UserLoggedInKey);
  }

  static Future<String?> GetUserEmailSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(UserEmailKey);
  }

  static Future<String?> GetUserNameSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(UserNameKey);
  }
}
