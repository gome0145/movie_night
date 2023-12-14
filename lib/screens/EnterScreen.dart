import 'package:flutter/material.dart';
import 'package:movie_night/components/button.dart';
import '../utils/http_helper.dart';
import '../model/movieNight.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();

  Future<MovieNight?> fetchCode(int code) async {
    try {
      MovieNight result = await HttpHelper.fetchEnterCode('get', code);
      return result;
    } catch (ex) {
      throw ex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter the code"),
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: codeController,
                style: Theme.of(context).textTheme.displayMedium,
                cursorColor: Theme.of(context).highlightColor,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.indigo),
                    hintText: 'Enter the code'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a code';
                  } else if (value.length != 4) {
                    return 'Code must be exactly 4 digits';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 250,
            ),
            MyButton(
              text: "Continue",
              icon: Icons.ac_unit_sharp,
              onTap: () async {
                FormState? fs = _formKey.currentState;
                if (fs!.validate()) {
                  String codeText = codeController.text;
                  int code = int.parse(codeText);
                  try {
                    MovieNight? result = await fetchCode(code);
                    if (result != null) {
                      Navigator.pushNamed(context, '/movies');
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Ups!"),
                            content:
                                const Text("Something went wrong, try again"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (ex) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Error fetching code: $ex"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
