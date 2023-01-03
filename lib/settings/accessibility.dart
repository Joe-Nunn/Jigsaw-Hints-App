import 'package:flutter/material.dart';
import 'package:jigsaw_hints/app_bar.dart';
import 'package:jigsaw_hints/constants.dart';

class AccessibilitySettings extends StatefulWidget {
  const AccessibilitySettings({super.key});

  @override
  State<AccessibilitySettings> createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  bool playAnimations = false;

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
            trailing: Text("MEDIUM"),
            onTap: () => {}),
      ];
}
