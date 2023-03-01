import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_hints/provider/box_cover.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';
import 'package:jigsaw_hints/provider/images.dart';
import 'package:jigsaw_hints/provider/torch_provider.dart';
import 'package:jigsaw_hints/settings/default_settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/camera_screen.dart';
import '../utils/constants.dart' as constants;
import '../settings/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
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
    return MaterialApp(
      title: 'Jigsaw Puzzle Solver',
      theme: ThemeData(
          fontFamily: 'Rubik',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: constants.primaryColour,
            secondary: constants.secondaryColour,
            tertiary: constants.tertiaryColour,
          ),
          textTheme: const TextTheme(
            labelMedium: TextStyle(fontSize: 18, fontFamily: 'Rubik'),
            titleMedium: TextStyle(fontSize: 20, fontFamily: 'Rubik'),
            bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Rubik'),
            bodyLarge: TextStyle(fontSize: 18, fontFamily: 'Rubik'),
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
