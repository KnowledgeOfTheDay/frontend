import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("You are not logged in, please log in to proceed."),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async => await Provider.of<FlutterAuth>(context, listen: false).login(),
              child: const Text("login"),
            ),
          ),
        ],
      ),
    );
  }
}
