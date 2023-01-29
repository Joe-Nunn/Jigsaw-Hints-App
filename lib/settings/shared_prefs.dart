import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProvider(this.sharedPreferences);

  Stream<SharedPreferences> get prefsState => sharedPreferences.asStream();
}

const String darkModeKey = "dark mode";
const String userNameKey = "user name";
const String hintAccuracyKey = "hint accuracy";
const String algorithmCorrectnessKey = "algorithm correctness";
const String fontSizeKey = "font size";
