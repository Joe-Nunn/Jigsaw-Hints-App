import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/input_dialog.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings extends StatefulWidget {
  const AccessibilitySettings({super.key});

  @override
  State<AccessibilitySettings> createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  late SharedPreferences sharedPrefs;
  bool playAnimations = false;
  late int fontSize;

  @override
  Widget build(BuildContext context) {
    initUserData(context);
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

  void initUserData(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    fontSize = sharedPrefs.getInt(fontSizeKey) ?? defaultFontSize;
  }

  List<Widget> get settingsTiles => [
        ListTile(
            leading: const Icon(
              Icons.motion_photos_off,
            ),
            title: const Text('Animations'),
            subtitle: const Text('Toggle animations'),
            trailing: Switch.adaptive(
              value: playAnimations,
              activeColor: defaultSliderActiveColour,
              inactiveTrackColor: defaultSliderInactiveColour,
              onChanged: (value) {
                setState(() {
                  playAnimations = value;
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
                  context, sharedPrefs, fontSizeKey, fontSize, FontSize.values,
                  titleText: "Font Size")).then((_) => setState(() {})),
        ),
      ];
}
