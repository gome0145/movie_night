import 'package:http/http.dart' as http;
//from pub.dev in the pubspec.yaml for dealing with any http(s) calls
// http.get, http.post
import 'dart:convert';
//for JSON conversion
import 'dart:async';
//for Futures (Promises)
import '../components/DeviceId.dart';

class HttpHelper {
  //A place to put all / any of our fetch calls
  //with static HttpHelper.fetch()
  //without static HttpHelper.fetch()

  static Future<MovieNight> fetchCode(String method) async {
    String deviceId = await SharedPreferencesManager.getDeviceId();
    Uri uri = Uri.parse("https://movie-night-api.onrender.com/start-session?device_id=$deviceId");
    //convert the url String into a Uri object.

    await Future<bool>.delayed(
      Duration(seconds: 3),
          () => true,
    );

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
          SharedPreferencesManager.setSessionID(data['session_id'].toString());
          return MovieNight.fromJson(data);
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }

  static Future<MovieNight> fetchEnterCode(String method, int code) async {
    String deviceId = await SharedPreferencesManager.getDeviceId();
    Uri uri = Uri.parse("https://movie-night-api.onrender.com/start-session?device_id=$deviceId&code=$code");

    await Future<bool>.delayed(
      Duration(seconds: 3),
          () => true,
    );

    switch (method) {
      case 'get':
        http.Response resp = await http.get(uri);
        if (resp.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
          SharedPreferencesManager.setSessionID(data['session_id'].toString());
          return MovieNight.fromJson(data);
        } else {
          throw Exception('Did not get a valid response.');
        }

      default:
        throw Exception('Not a valid method.');
    }
  }


}

//Data Models

class MovieNight {
  late String message;
  late String code;
  late String sessionId;

  MovieNight({
    required this.message,
    required this.code,
    required this.sessionId,
  });

  MovieNight.fromJson(Map<String, dynamic> data) {
    message = data['data']['message'] ?? '';
    code = data['data']['code'] ?? '';
    sessionId = data['data']['session_id'] ?? '';
  }
}