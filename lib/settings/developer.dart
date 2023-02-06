import 'package:flutter/material.dart';
import 'package:jigsaw_hints/main/main.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/app_version.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => _DeveloperSettingsState();
}

class _DeveloperSettingsState extends State<DeveloperSettings> {
  late SharedPreferences sharedPrefs;
  late bool isDebugMode;
  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    isDebugMode = sharedPrefs.getBool(SharedPrefsKeys.debugMode.name) ?? defaultDebugMode;
    return Scaffold(
      appBar: const JigsawAppBar(
        title: "Settings",
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultContentPaddingBig),
        children: settingsTiles,
      ),
    );
  }

  List<Widget> get settingsTiles => [
        ListTile(
            leading: const Icon(Icons.network_ping),
            title: const Text('Debug Mode'),
            subtitle: const Text('Send test data to server'),
            trailing: Switch.adaptive(
              value: isDebugMode,
              activeColor: defaultSliderActiveColour,
              inactiveTrackColor: defaultSliderInactiveColour,
              onChanged: (value) {
                setState(() {
                  isDebugMode = value;
                  sharedPrefs.setBool(SharedPrefsKeys.debugMode.name, value);
                });
              },
            ),
            onTap: () => {}),
      ];
}
