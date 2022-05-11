import 'package:shared_preferences/shared_preferences.dart';

import '../DB Connectivity/api/authentication_api.dart';

class GetUserData {
  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("accessToken");
    var user = await getUserData(token);
    return user;
  }
}
