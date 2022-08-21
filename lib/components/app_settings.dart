import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      title: AppLocalizations.of(context)!.settingsTitle,
      children: [
        // SettingsGroup(title: "General", children: [
        //   DropDownSettingsTile(
        //       title: "Displaymode", settingKey: SettingsKey.displayMode, selected: 0, values: const {0: "System", 1: "Light", 2: "Dark"})
        // ]),
        SettingsGroup(title: AppLocalizations.of(context)!.settingsGroupExperimental, children: [
          SwitchSettingsTile(
              title: AppLocalizations.of(context)!.settingsUseFastCreationTitle,
              subtitle: AppLocalizations.of(context)!.settingsUseFastCreationDescription,
              settingKey: SettingsKey.useFastCreation),
        ]),
        if (kDebugMode)
          SettingsGroup(title: AppLocalizations.of(context)!.settingsGroupDebug, children: [
            TextInputSettingsTile(
              title: AppLocalizations.of(context)!.settingServerTitle,
              settingKey: SettingsKey.server,
              initialValue: "kotd.jonascurth.de",
            ),
          ]),
      ],
    );
  }
}
