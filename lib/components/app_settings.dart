import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import '../helpers/settings_key.dart';

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
        // SettingsGroup(title: "General", children: [
        //   DropDownSettingsTile(
        //       title: "Displaymode", settingKey: SettingsKey.displayMode, selected: 0, values: const {0: "System", 1: "Light", 2: "Dark"})
        // ]),
        SettingsGroup(title: "Experimental", children: [
          SwitchSettingsTile(
              title: "Use fast creation",
              subtitle: "Decides wheather links should be created directly or not.",
              settingKey: SettingsKey.useFastCreation),
        ]),
        if (kDebugMode)
          SettingsGroup(title: "Debug", children: [
            TextInputSettingsTile(
              title: "Server",
              settingKey: SettingsKey.server,
              initialValue: "kotd.jonascurth.de",
            ),
          ]),
      ],
    );
  }
}
