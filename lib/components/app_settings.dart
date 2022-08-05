import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:kotd/helpers/settings_key.dart';

class AppSettings extends StatefulWidget {
  static const String routeName = "settings";

  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: "Application Settings",
      children: [
        SettingsGroup(title: "Experimental", children: [
          SwitchSettingsTile(
              title: "Use fast creation",
              subtitle: "Decides wheather links should be created directly or not.",
              settingKey: SettingsKey.useFastCreation),
        ])
      ],
    );
  }
}
