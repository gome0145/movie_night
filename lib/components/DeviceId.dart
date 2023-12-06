import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _deviceIdKey = 'deviceId';

  // Método para obtener el ID del dispositivo
  static Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    // Si no se ha almacenado un ID previamente, genera uno y guárdalo
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = await PlatformDeviceId.getDeviceId;
      prefs.setString(_deviceIdKey, deviceId!);
    }

    return deviceId;
  }


  // Método para obtener sessionID
  static Future<String?> getSessionID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionID = prefs.getString("sessionId");

    return sessionID;
  }

  static Future<String?> setSessionID(String session) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("sessionID", <String>[session!]);
  }

  static Future<void> addSessionID(String session) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> currentSessions = prefs.getStringList("sessionID") ?? <String>[];

    currentSessions.add(session);

    prefs.setStringList("sessionID", currentSessions);
  }


}