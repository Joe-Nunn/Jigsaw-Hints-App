import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/ui/dialogs/input_dialog.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  late SharedPreferences sharedPrefs;
  // Values
  late int hintAccuracy;
  late int algorithmCorrectness;

  @override
  Widget build(BuildContext context) {
    initUserData(context);
    return Scaffold(
      appBar: const JigsawAppBar(
        title: "Settings",
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultBigContentPadding),
        children: settingsTiles,
      ),
    );
  }

  void initUserData(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    hintAccuracy = sharedPrefs.getInt(hintAccuracyKey) ?? defaultHintAccuracy;
    algorithmCorrectness = sharedPrefs.getInt(algorithmCorrectnessKey) ??
        defaultAlgorithmCorrectness;
  }

  List<Widget> get settingsTiles => [
        ListTile(
          leading: const Icon(Icons.help_center),
          title: const Text('Hint Accuracy'),
          subtitle: const Text('Set how accurate the hint box should be'),
          trailing: Text("${hintAccuracy.round()}"),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => inputDialogSlider(
                  context, sharedPrefs, hintAccuracyKey, hintAccuracy,
                  titleText: "Hint Accuracy")).then((_) => setState(() {})),
        ),
        Container(
          height: 10,
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.flame),
          title: const Text('Algorithm Correctness'),
          subtitle: const Text('Set corectness level of the algorithm'),
          trailing: Text(
              describeEnum(AlgorithmCorrectness.values[algorithmCorrectness])
                  .toUpperCase()),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => inputDialogTextSlider(
                  context,
                  sharedPrefs,
                  algorithmCorrectnessKey,
                  algorithmCorrectness,
                  AlgorithmCorrectness.values,
                  titleText: "Hint Accuracy")).then((_) => setState(() {})),
        ),
      ];
}
