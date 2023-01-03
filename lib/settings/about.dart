import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jigsaw_hints/app_bar.dart';
import 'package:jigsaw_hints/constants.dart';

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
      ];
}
