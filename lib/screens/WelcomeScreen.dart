import 'package:flutter/material.dart';
import '../components/DeviceId.dart';
import '../components/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie night"),
      ),
      body: FutureBuilder(
        // Usa un FutureBuilder para esperar la obtención del ID del dispositivo
        future: SharedPreferencesManager.getDeviceId(),
        builder: (context, snapshot) {
          String deviceId = snapshot.data as String? ?? "Loading...";
          return Column(
            children: [
              MyButton(
                text: "Start session",
                onTap: () {
                  Navigator.pushNamed(context, '/sharecode');
                },
              ),
              Text("Choose an option"),
              MyButton(
                text: "Enter the code",
                onTap: () {
                  Navigator.pushNamed(context, '/entercode');
                },
              ),
              Text('Device ID: $deviceId'),
            ],
          );
        },
      ),

    );
  }
}