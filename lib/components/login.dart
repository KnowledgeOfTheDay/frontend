import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.authNotLoggedIn),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async => await Provider.of<FlutterAuth>(context, listen: false).login(),
              child: Text(AppLocalizations.of(context)!.authLogin),
            ),
          ),
        ],
      ),
    );
  }
}
