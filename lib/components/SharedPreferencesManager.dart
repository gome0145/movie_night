import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static setDeviceId(String platform) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = "";
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (platform == "android") {
      AndroidDeviceInfo android = await deviceInfoPlugin.androidInfo;
      deviceId = android.id;
    } else if (platform == "iOS") {
      IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
      deviceId = ios.identifierForVendor;
    }
    prefs.setString("deviceIdKey", deviceId!);
  }

  static Future<String?> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString("deviceIdKey");
    return deviceId;
  }

  static Future<String?> getSessionID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionID = prefs.getString("sessionID");

    return sessionID;
  }

  static setSessionID(String session) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sessionID", session);
  }

  static setVote(bool vote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("vote", vote);
  }

  static Future<bool?> getVote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("vote");
  }

  static setMovieInfo(List<String> movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("movieInfo", movie);
  }

  static Future<List<String>?> getMovieInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("movieInfo");
  }
}
