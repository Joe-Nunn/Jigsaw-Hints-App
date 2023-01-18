import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

StatefulBuilder inputDialogText(
    BuildContext context, SharedPreferences? sharedPrefs, String key,
    {String titleText = "Enter some text"}) {
  bool textFieldIsEmpty = true;
  final TextEditingController controller = TextEditingController();
  return StatefulBuilder(
    builder: ((context, setState) {
      return AlertDialog(
        title: Center(child: Text(titleText)),
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultDialogBorderRadius))),
        content: TextField(
          controller: controller,
          onChanged: (value) {
            setState(
              () {
                if (value.isNotEmpty) {
                  textFieldIsEmpty = false;
                } else {
                  textFieldIsEmpty = true;
                }
              },
            );
          },
        ),
        actions: [
          // Only show the button if the text field is not empty
          Visibility(
            visible: !textFieldIsEmpty,
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
                sharedPrefs?.setString(key, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    }),
  );
}

StatefulBuilder inputDialogTextBox({String titleText = "Enter some text"}) {
  bool textFieldIsEmpty = true;
  final TextEditingController controller = TextEditingController();
  return StatefulBuilder(
    builder: ((context, setState) {
      return AlertDialog(
        title: Center(child: Text(titleText)),
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultDialogBorderRadius))),
        content: TextField(
          maxLines: 7,
          controller: controller,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            hintText: 'Let us know what do you think...',
            hintStyle: TextStyle(fontSize: 12),
          ),
          onChanged: (value) {
            setState(
              () {
                if (value.isNotEmpty) {
                  textFieldIsEmpty = false;
                } else {
                  textFieldIsEmpty = true;
                }
              },
            );
          },
        ),
        actions: [
          // Only show the button if the text field is not empty
          Visibility(
            visible: !textFieldIsEmpty,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              child: Text(
                "Send",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    }),
  );
}

StatefulBuilder inputDialogSlider(BuildContext context,
    SharedPreferences sharedPrefs, String key, int currentValue,
    {String titleText = "Set value using the slider"}) {
  bool valueHasChanged = false;
  int currentSliderValue = currentValue;
  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(titleText),
        content: Wrap(children: [
          Slider.adaptive(
            value: currentSliderValue.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            label: currentSliderValue.toString(),
            thumbColor: defaultSliderActiveColour,
            activeColor: defaultSliderActiveColour,
            inactiveColor: defaultSliderInactiveColour,
            onChanged: (double value) {
              setState(() {
                currentSliderValue = value.toInt();
                if (currentSliderValue != currentValue) {
                  valueHasChanged = true;
                } else {
                  valueHasChanged = false;
                }
              });
            },
          ),
        ]),
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
                sharedPrefs.setInt(key, currentSliderValue);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

StatefulBuilder inputDialogTextSlider(
    BuildContext context,
    SharedPreferences sharedPrefs,
    String key,
    int currentValue,
    List<dynamic> options,
    {String titleText = "Choose option using the slider"}) {
  bool valueHasChanged = false;
  int currentSliderValue = currentValue;
  return StatefulBuilder(
    builder: (context, setState) {
      return AlertDialog(
        title: Text(titleText),
        content: Wrap(children: [
          Slider.adaptive(
            value: currentSliderValue.toDouble(),
            min: 0,
            max: options.length - 1,
            divisions: options.length - 1,
            label: describeEnum(options[currentSliderValue]).toUpperCase(),
            thumbColor: defaultSliderActiveColour,
            activeColor: defaultSliderActiveColour,
            inactiveColor: defaultSliderInactiveColour,
            onChanged: (double value) {
              setState(() {
                currentSliderValue = value.toInt();
                if (currentSliderValue != currentValue) {
                  valueHasChanged = true;
                } else {
                  valueHasChanged = false;
                }
              });
            },
          ),
        ]),
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
                sharedPrefs.setInt(key, currentSliderValue);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
