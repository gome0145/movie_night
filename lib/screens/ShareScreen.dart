import 'package:flutter/material.dart';
import 'package:movie_night/components/button.dart';
import '../utils/http_helper.dart';


class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late Future<MovieNight> apiData = Future<MovieNight>.value(MovieNight(message: '', code: '', sessionId: ''));// Variable para almacenar los datos de la API

  void fetchData() {
    try {
      apiData =
          HttpHelper.fetchCode('get');
      //State variable now holds a Future and calls the fetch method immediately
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Share Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<MovieNight>(
          future: apiData,
          builder: (BuildContext context, AsyncSnapshot<MovieNight> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.code),
                  const Text("Share this code"),
                  MyButton(text: "Select movies", onTap: () {
                    Navigator.pushNamed(context, '/movies');
                  },
                  )
                ],
              );
            }
            else if (snapshot.hasError) {
              //tell the user you don't like them
              return const Center(child: FlutterLogo(size: 40));
            } else {
              //tell them to wait...
              return  const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
