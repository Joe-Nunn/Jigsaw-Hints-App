import 'package:flutter/cupertino.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:jigsaw_hints/settings/shared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isAnimationEnabled(BuildContext context) {
    SharedPreferences sharedPrefs = context.watch<SharedPreferences>();
    return sharedPrefs.getBool(SharedPrefsKeys.enableAnimations.name) ?? defaultEnableAnimations;
}

