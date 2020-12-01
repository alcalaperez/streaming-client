import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesData {
  SharedPreferences sp;
  String username;
  String picUrl;

  Future<void> reset() async {
    sp = await SharedPreferences.getInstance();
    var usern = sp.getString("username");
    var pic = sp.getString("picUrl");

    if (usern != null) {
      username = usern;
    }

    if (pic != null) {
      picUrl = pic;
    }
  }
}
