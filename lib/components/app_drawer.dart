import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_settings.dart';
import 'package:provider/provider.dart';
import 'auth_button.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _getlogoutButton(BuildContext context) {
    return AuthButton(AppLocalizations.of(context)!.authLogout, () {
      Provider.of<FlutterAuth>(context, listen: false).logout();
    });
  }

  Widget _getLoginButton(BuildContext context) {
    return AuthButton(AppLocalizations.of(context)!.authLogin, () {
      Provider.of<FlutterAuth>(context, listen: false).login();
      Navigator.of(context).pop();
    });
  }

  Widget _getAuthButton(BuildContext context) {
    Widget auth;
    if (Provider.of<FlutterAuth>(context, listen: true).isLoggedIn) {
      auth = _getlogoutButton(context);
    } else {
      auth = _getLoginButton(context);
    }
    return auth;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: IconButton(
                    onPressed: () => Navigator.pushNamed(context, AppSettings.routeName),
                    splashColor: Colors.transparent,
                    icon: const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _getAuthButton(context),
        ],
      ),
    );
  }
}
