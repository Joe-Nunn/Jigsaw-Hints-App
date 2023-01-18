import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/ui/info_dialog.dart';
import 'package:jigsaw_hints/main/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutSettings extends StatefulWidget {
  const AboutSettings({super.key});

  @override
  State<AboutSettings> createState() => _AboutSettingsState();
}

class _AboutSettingsState extends State<AboutSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const JigsawAppBar(
        title: "Settings",
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultContentPadding),
        children: settingsTiles,
      ),
    );
  }

  List<Widget> get settingsTiles => [
        ListTile(
            leading: const Icon(
              Icons.perm_device_info,
            ),
            title: const Text('App Version'),
            subtitle: const Text('Installed version'),
            trailing: const Text('1.0.0'),
            onTap: () => {}),
        ListTile(
            leading: const Icon(
              Icons.restart_alt_outlined,
            ),
            title: const Text('Reset Settings'),
            subtitle: const Text('Set all settings back to default'),
            onTap: () => showInfoDialog(context,
                title: "Resetting all user settings",
                content: "Are you sure?",
                titleBgColor: Colors.redAccent,
                rightButton: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: yesButton(context),
                ),
                leftButton: noButton(context))),
      ];

  Widget yesButton(BuildContext context) {
    return TextButton(
      child: Text("Yes", style: Theme.of(context).textTheme.labelMedium),
      onPressed: () {
        resetUserData();
        Navigator.of(context).pop();
      },
    );
  }

  Widget noButton(BuildContext context) {
    return TextButton(
      child: Text("No", style: Theme.of(context).textTheme.labelMedium),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  resetUserData() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
    if (!mounted) return;
    MyApp.of(context).setState(() {});
  }
}
