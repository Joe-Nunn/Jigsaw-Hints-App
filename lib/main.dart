import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jigsaw_hints/camera_mode.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera_screen.dart';
import 'constants.dart' as constants;
import 'settings/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  runApp(MultiProvider(providers: [
    Provider<SharedPreferencesProvider?>(
        create: (_) =>
            SharedPreferencesProvider(SharedPreferences.getInstance())),
    StreamProvider(
        create: (context) =>
            context.read<SharedPreferencesProvider>().prefsState,
        initialData: null),
    ChangeNotifierProvider(create: (context) => CameraModeProvider()),
  ], child: MyApp(cameras: cameras)));
}

class MyApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  State<MyApp> createState() => _MyAppState();

  static State<MyApp> of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences sharedPrefs;
  @override
  Widget build(BuildContext context) {
    sharedPrefs = context.watch<SharedPreferences>();
    return MaterialApp(
      title: 'Jigsaw Puzzle Solver',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: constants.primaryColour,
            secondary: constants.secondaryColour,
            tertiary: constants.tertiaryColour,
          ),
          textTheme: const TextTheme(
            labelMedium: TextStyle(fontSize: 18, fontFamily: 'Rubik'),
            titleMedium: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
            bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Rubik'),
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          )),
      darkTheme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            labelMedium: TextStyle(fontSize: 18, fontFamily: 'Rubik'),
            titleMedium: TextStyle(
                fontSize: 20,
                fontFamily: 'Rubik',
                color: Color.fromARGB(255, 138, 138, 138)),
            bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Rubik'),
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          )),
      themeMode: (sharedPrefs.getBool(darkModeKey) ?? defaultDarkMode)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: CameraScreen(cameras: widget.cameras),
    );
  }
}
