import 'package:shared_preferences/shared_preferences.dart';

loginStatus(islogged) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool("isLogged", islogged);
}

accessToken(token) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("accessToken", token);
}

getUser(user) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("getUser", user);
}

getaccessToken() async {
  String token = '';

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  token = sharedPreferences.getString("accessToken").toString();
  return token;
}
