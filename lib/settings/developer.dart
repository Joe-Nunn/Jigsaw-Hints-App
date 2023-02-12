import 'package:flutter/material.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:jigsaw_hints/ui/dialogs/input_dialog.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';

class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => _DeveloperSettingsState();
}

class _DeveloperSettingsState extends State<DeveloperSettings> {
  late SharedPreferences sharedPrefs;
  late bool isDebugMode;
  late String serverAddress;
  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    isDebugMode =
        sharedPrefs.getBool(SharedPrefsKeys.debugMode.name) ?? defaultDebugMode;
    serverAddress = sharedPrefs.getString(SharedPrefsKeys.serverAddress.name) ??
        defaultServerAddress;
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
        ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: const Text('Server Address'),
            subtitle: const Text('Set the server address'),
            trailing: GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: ((context) => inputDialogText(
                      context, sharedPrefs, SharedPrefsKeys.serverAddress.name,
                      titleText: "Enter server address"))).then(
                  (_) => setState(() {})),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
                child: Marquee(
                  style: const TextStyle(
                      backgroundColor: Color.fromARGB(255, 245, 245, 245)),
                  text: serverAddress,
                  blankSpace: 50.0,
                  velocity: 20.0,
                  startPadding: 10.0,
                  fadingEdgeStartFraction: 0.2,
                  fadingEdgeEndFraction: 0.2,
                  pauseAfterRound: const Duration(seconds: 5),
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
            ),
            onTap: () => {}),
      ];
}
