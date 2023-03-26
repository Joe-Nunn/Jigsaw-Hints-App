import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/main/main.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  late SharedPreferences sharedPrefs;
  // Values
  late bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    isDarkMode = sharedPrefs.getBool(SharedPrefsKeys.darkMode.name) ?? defaultDarkMode;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            leading: const Icon(
              Icons.dark_mode_rounded,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark mode'),
            trailing: Switch.adaptive(
              value: isDarkMode,
              activeColor: defaultSliderActiveColour,
              inactiveTrackColor: defaultSliderInactiveColour,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  sharedPrefs.setBool(SharedPrefsKeys.darkMode.name, value);
                  MyApp.of(context).setState(() {});
                });
              },
            ),
            onTap: () => {}),
      ];
}
