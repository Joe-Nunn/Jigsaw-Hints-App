import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/ui/menus/app_bar.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/ui/dialogs/input_dialogs.dart';
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
  late int algorithmType;

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
    hintAccuracy = sharedPrefs.getInt(SharedPrefsKeys.hintAccuracy.name) ??
        defaultHintAccuracy;
    algorithmType = sharedPrefs.getInt(SharedPrefsKeys.algorithmType.name) ??
        defaultAlgorithmType;
  }

  List<Widget> get settingsTiles => [
        ListTile(
          leading: const Icon(Icons.help_center),
          title: const Text('Hint Accuracy'),
          subtitle: const Text('Set the hint box accuracy'),
          trailing: SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("${hintAccuracy.round()}%"))),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => inputDialogSlider(context,
                  sharedPrefs, SharedPrefsKeys.hintAccuracy.name, hintAccuracy,
                  titleText: "Hint Accuracy")).then((_) => setState(() {})),
        ),
        Container(
          height: 10,
        ),
        ListTile(
          leading: const Icon(CupertinoIcons.flame),
          title: const Text('Algorithm'),
          subtitle: const Text('Choose solving method'),
          trailing: SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(describeEnum(AlgorithmType.values[algorithmType])
                  .toUpperCase()),
            ),
          ),
          onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => radioButtonDialog(
                  context,
                  sharedPrefs,
                  SharedPrefsKeys.algorithmType.name,
                  algorithmType,
                  titleText: "Algorithm type")).then((_) => setState(() {})),
        ),
      ];

  StatefulBuilder radioButtonDialog(BuildContext context,
      SharedPreferences sharedPrefs, String key, int currentValue,
      {String titleText = "Choose option"}) {
    bool valueHasChanged = false;
    int currentButtonValue = currentValue;
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(titleText),
          content: Wrap(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        activeColor: themeLightBlue,
                        value: 0,
                        groupValue: currentButtonValue,
                        onChanged: (value) {
                          setState(() {
                            currentButtonValue = value!;
                            if (currentButtonValue != currentValue) {
                              valueHasChanged = true;
                            } else {
                              valueHasChanged = false;
                            }
                          });
                        },
                      ),
                      const Text('Hint Box + Heatmap'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        activeColor: themeLightBlue,
                        value: 1,
                        groupValue: currentButtonValue,
                        onChanged: (value) {
                          setState(() {
                            currentButtonValue = value!;
                            if (currentButtonValue != currentValue) {
                              valueHasChanged = true;
                            } else {
                              valueHasChanged = false;
                            }
                          });
                        },
                      ),
                      const Text('Heatmap Only'),
                    ],
                  ),
                ],
              )
            ],
          ),
          actions: <Widget>[
            Visibility(
              visible: valueHasChanged,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                child: Text(
                  "Apply",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
                onPressed: () {
                  sharedPrefs.setInt(key, currentButtonValue);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
