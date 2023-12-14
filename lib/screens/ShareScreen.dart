import 'package:flutter/material.dart';
import 'package:movie_night/components/button.dart';
import '../utils/http_helper.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({Key? key}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  late Future<MovieNight> apiData = Future<MovieNight>.value(
      MovieNight(message: '', code: '', sessionId: ''));

  void fetchData() {
    try {
      apiData = HttpHelper.fetchCode('get');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("This is the code!"),
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<MovieNight>(
          future: apiData,
          builder: (BuildContext context, AsyncSnapshot<MovieNight> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.code,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Share this code",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    text: "Select movies",
                    onTap: () {
                      Navigator.pushNamed(context, '/movies');
                    },
                    icon: Icons.ac_unit_sharp,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: AlertDialog(
                title: Text("Match!"),
                content: Text("¡Has encontrado un match!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                    child: Text("OK"),
                  ),
                ],
              ));
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.indigo,
              ));
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
