import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/provider/torch_provider.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/camera_screen.dart';
import '../utils/constants.dart' as constants;
import '../settings/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Request the storage permission
  await Permission.storage.request();
  // Hide the status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Ensure the app is launched in portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Ensure the SharedPreferences are initialized
  final sharedPrefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    Provider<SharedPreferencesProvider?>(
        create: (_) =>
            SharedPreferencesProvider(SharedPreferences.getInstance())),
    StreamProvider(
        create: (context) =>
            context.read<SharedPreferencesProvider>().prefsState,
        initialData: sharedPrefs),
    ChangeNotifierProvider(create: (context) => CameraModeProvider()),
    ChangeNotifierProvider(create: (context) => ImagesProvider()),
    ChangeNotifierProvider(create: (context) => BoxCoverProvider()),
    ChangeNotifierProvider(create: (context) => TorchProvider()),
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
    int fontSize =
        sharedPrefs.getInt(SharedPrefsKeys.fontSize.name) ?? defaultFontSize;
    double fontSizeMultiplier;
    if (fontSize == 0) {
      fontSizeMultiplier = 0.5;
    } else if (fontSize == 1) {
      fontSizeMultiplier = 1.0;
    } else if (fontSize == 2) {
      fontSizeMultiplier = 1.5;
    } else {
      fontSizeMultiplier = 1.0;
    }
    return MaterialApp(
      title: 'Jigsaw Puzzle Solver',
      theme: ThemeData(
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: constants.primaryColour,
            secondary: constants.secondaryColour,
            tertiary: constants.tertiaryColour,
          ),
          textTheme: TextTheme(
            labelMedium:
                TextStyle(fontSize: 18.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
            titleMedium:
                TextStyle(fontSize: 20.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
            bodyMedium:
                TextStyle(fontSize: 16.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
            bodyLarge:
                TextStyle(fontSize: 18.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          )),
      darkTheme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            labelMedium:
                TextStyle(fontSize: 18.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
            titleMedium: TextStyle(
                fontSize: 20.0 * fontSizeMultiplier,
                fontFamily: 'Rubik',
                color: const Color(0xFF8A8A8A)),
            bodyMedium:
                TextStyle(fontSize: 16.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
            bodyLarge:
                TextStyle(fontSize: 18.0 * fontSizeMultiplier, fontFamily: 'Rubik'),
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          )),
      themeMode: (sharedPrefs.getBool(SharedPrefsKeys.darkMode.name) ??
              defaultDarkMode)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => CameraScreen(cameras: widget.cameras),
      },
    );
  }
}
