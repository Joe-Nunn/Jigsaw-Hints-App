import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/constants.dart';
import 'package:jigsaw_hints/settings/about.dart';
import 'package:jigsaw_hints/settings/accessibility.dart';
import 'package:jigsaw_hints/settings/appearance.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/general.dart';
import 'package:jigsaw_hints/settings/input_dialog.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences sharedPrefs;

  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(defaultAppBarPadding),
            child: Text(
              "Settings",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
        flexibleSpace: const Image(
          image: AssetImage('images/appbar_bg.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultContentPadding),
        child: settingTiles(),
      ),
    );
  }

  Widget settingTiles() {
    var userName = sharedPrefs.getString(userNameKey) ?? defaultUserName;
    return Padding(
      padding: const EdgeInsets.all(defaultContentPadding),
      child: ListView(
        children: [
          // User card
          SmallUserCard(
            cardColor: const Color.fromARGB(255, 95, 170, 231),
            userName: userName,
            userProfilePic: const AssetImage("images/user_avatar.png"),
            onTap: () => showDialog(
                    context: context,
                    builder: ((context) => inputDialogText(
                        context, sharedPrefs, userNameKey,
                        titleText: "Enter your name")))
                .then((_) => setState(() {})),
          ),
          SettingsGroup(
            items: [
              SettingsItem(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        child: const GeneralSettings(),
                        type: PageTransitionType.fade)),
                icons: CupertinoIcons.settings,
                iconStyle: IconStyle(backgroundColor: Colors.amber),
                title: 'General',
                subtitle: "Hint accuracy and more",
              ),
              SettingsItem(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        child: const AppearanceSettings(),
                        type: PageTransitionType.fade)),
                icons: CupertinoIcons.pencil_outline,
                iconStyle: IconStyle(),
                title: 'Appearance',
                subtitle: "Make the app yours",
              ),
            ],
          ),
          SettingsGroup(
            items: [
              SettingsItem(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        child: const AccessibilitySettings(),
                        type: PageTransitionType.fade)),
                icons: Icons.accessibility_new,
                iconStyle: IconStyle(
                  backgroundColor: Colors.indigo,
                ),
                title: 'Accessibility',
                subtitle: "Configure to your needs",
              ),
              SettingsItem(
                onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            child: const AboutSettings(),
                            type: PageTransitionType.fade))
                    .then((_) => setState(() {})),
                icons: Icons.info_rounded,
                iconStyle: IconStyle(
                  backgroundColor: Colors.purple,
                ),
                title: 'About',
                subtitle: "Learn more about the App",
              ),
              SettingsItem(
                onTap: () => showDialog(
                    context: context,
                    builder: ((context) =>
                        inputDialogTextBox(titleText: "Feedback Form"))),
                icons: Icons.mail,
                iconStyle: IconStyle(
                  backgroundColor: const Color.fromARGB(255, 175, 175, 175),
                ),
                title: 'Send Feedback',
                subtitle: "Help us improve the App",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Setting {
  final String name;
  int value;

  Setting({this.name = "Default Name", this.value = 0});
}
