import 'package:flutter/material.dart';
import 'package:movie_night/components/button.dart';

import '../utils/http_helper.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController codeController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Enter Code"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Enter the code"),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Code',
                  icon: Icon(Icons.numbers),
                  hintText: 'Enter the code',
                  errorText: "Is not a valid code"),
              onSaved: (String? value) {
                print('You saved $value');
              },
            ),
            MyButton(text: "Continue", onTap: () async {
              FormState? fs = _formKey.currentState;
              if (fs!.validate()) {
                //TODO: validar que el codigo solo sean 4 digitos
                //TODO: poner alert para notificaciones
                int code = int.parse(codeController.text);
                try {
                  MovieNight result = await HttpHelper.fetchEnterCode('get', code);
                  print('Result: $result');
                  Navigator.pushNamed(context, '/movies');
                }
                catch (error){
                  print("Error: $error");
                }

              }
            },
            )
          ],
        ),
      ),);
  }
}
