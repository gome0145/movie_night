import 'package:flutter/material.dart';
import '../components/SharedPreferencesManager.dart';
import '../components/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movie night",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: SharedPreferencesManager.setDeviceId(
            Theme.of(context).platform.name),
        builder: (context, snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Welcome to Movie Match!",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Image(
                image: AssetImage('images/popcorn.png'),
                fit: BoxFit.contain,
                width: 150,
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                "Please choose an option",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 50,
              ),
              MyButton(
                text: "Create a session",
                onTap: () {
                  Navigator.pushNamed(context, '/sharecode');
                },
                icon: Icons.add_circle,
              ),
              const SizedBox(
                height: 50,
              ),
              MyButton(
                text: "I have a code!",
                onTap: () {
                  Navigator.pushNamed(context, '/entercode');
                },
                icon: Icons.keyboard,
              ),
            ],
          );
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
