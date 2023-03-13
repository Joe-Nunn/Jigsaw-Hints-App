import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/main/main.dart';
import 'package:jigsaw_hints/pages/widgets/accessibility_statement.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/ui/dialogs/input_dialogs.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings extends StatefulWidget {
  const AccessibilitySettings({super.key});

  @override
  State<AccessibilitySettings> createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  late SharedPreferences sharedPrefs;
  late bool enableAnimations;
  late int fontSize;

  @override
  Widget build(BuildContext context) {
    initUserData(context);
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

  void initUserData(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    fontSize =
        sharedPrefs.getInt(SharedPrefsKeys.fontSize.name) ?? defaultFontSize;
    enableAnimations = sharedPrefs
            .getBool(SharedPrefsKeys.enableAnimations.name) ?? defaultEnableAnimations;
  }

  List<Widget> get settingsTiles => [
        ListTile(
            leading: const Icon(
              Icons.motion_photos_off,
            ),
            title: const Text('Animations'),
            subtitle: const Text('Toggle animations'),
            trailing: Switch.adaptive(
              value: enableAnimations,
              activeColor: defaultSliderActiveColour,
              inactiveTrackColor: defaultSliderInactiveColour,
              onChanged: (value) {
                setState(() {
                  enableAnimations = value;
                  sharedPrefs.setBool(SharedPrefsKeys.enableAnimations.name, value);
                  MyApp.of(context).setState(() {});
                });
              },
            ),
            onTap: () => {}),
        ListTile(
          leading: const Icon(Icons.format_size),
          title: const Text('Font Size'),
          subtitle: const Text('Change the font size'),
          trailing: Text(describeEnum(FontSize.values[fontSize]).toUpperCase()),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => inputDialogTextSlider(
                  context,
                  sharedPrefs,
                  SharedPrefsKeys.fontSize.name,
                  fontSize,
                  FontSize.values,
                  titleText: "Font Size")).then((_) => setState(() {
                MyApp.of(context).setState(() {});
              })),
        ),
        // Accessibility statemend
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Statement'),
          subtitle: const Text('Read the accessibility statement'),
          onTap: (() => Navigator.push(
              context,
              PageTransition(
                  child: const AccessibilityStatementPage(),
                  type: PageTransitionType.fade))),
        ),
      ];
}