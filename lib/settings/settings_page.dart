import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/settings/developer.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/settings/about.dart';
import 'package:jigsaw_hints/settings/accessibility.dart';
import 'package:jigsaw_hints/settings/appearance.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/general.dart';
import 'package:jigsaw_hints/ui/dialogs/input_dialogs.dart';
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
      resizeToAvoidBottomInset: false,
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
            child: Opacity(
              opacity: 0.5,
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
        padding: const EdgeInsets.all(defaultContentPaddingBig),
        child: settingTiles(),
      ),
    );
  }

  Widget settingTiles() {
    var userName =
        sharedPrefs.getString(SharedPrefsKeys.userName.name) ?? defaultUserName;
    return Padding(
        padding: const EdgeInsets.all(defaultContentPaddingBig),
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
                      context,
                      sharedPrefs,
                      SharedPrefsKeys.userName.name,
                      titleText: "Enter your name",
                      maxLength: 30,
                      allowedCharacters: "[0-9a-zA-Z ]",
                    )),
              ).then((_) => setState(() {})),
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () => openSubPage(const GeneralSettings()),
                  icons: CupertinoIcons.settings,
                  iconStyle: IconStyle(backgroundColor: Colors.amber),
                  title: 'General',
                  subtitle: "Hint accuracy and more",
                ),
                SettingsItem(
                  onTap: () => openSubPage(const AppearanceSettings()),
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
                  onTap: () => openSubPage(const AccessibilitySettings()),
                  icons: Icons.accessibility_new,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.indigo,
                  ),
                  title: 'Accessibility',
                  subtitle: "Configure to your needs",
                ),
                SettingsItem(
                  onTap: () => openSubPage(const AboutSettings()),
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about the App",
                ),
              ],
            ),
            SettingsGroup(
              items: [
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
                SettingsItem(
                  onTap: () => openSubPage(const DeveloperSettings()),
                  icons: Icons.code,
                  iconStyle: IconStyle(
                    backgroundColor: const Color.fromARGB(255, 126, 104, 92),
                  ),
                  title: 'Developer',
                  subtitle: "Settings for the developers",
                ),
              ],
            ),
          ],
        ));
  }

  Future<void> openSubPage(Widget page) {
    return Navigator.push(
            context, PageTransition(child: page, type: PageTransitionType.fade))
        .then((_) => setState(() {}));
  }
}
