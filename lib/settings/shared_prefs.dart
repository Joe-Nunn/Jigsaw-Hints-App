import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProvider(this.sharedPreferences);

  Stream<SharedPreferences> get prefsState => sharedPreferences.asStream();
}

enum SharedPrefsKeys {
  darkMode,
  userName,
  hintAccuracy,
  algorithmType,
  fontSize,
  debugMode,
  serverAddress,
  enableAnimations,
}
