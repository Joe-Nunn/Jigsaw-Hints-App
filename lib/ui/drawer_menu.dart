import 'package:flutter/material.dart';
import 'package:jigsaw_hints/pages/camera_screen.dart';
import 'package:jigsaw_hints/settings/settings_page.dart';
import 'package:showcaseview/showcaseview.dart';

import '../utils/constants.dart';
import '../pages/gallery_screen.dart';

class DrawerMenu extends StatelessWidget {
  final List<GlobalKey> globalKeys;

  const DrawerMenu({Key? key, required this.globalKeys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      child: ListView(
        children: [
          Container(
            color: logoBgColour,
            child: DrawerHeader(
              child: Center(
                child: Image.asset(
                  'images/jigsaw_logo.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.photo_album,
            ),
            title: const MenuText('Saved Boxes'),
            onTap: () {
              Navigator.push(context,
                  slideIn(GalleryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const MenuText('Settings'),
            onTap: () {
              Navigator.push(context, slideIn(const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.question_mark,
            ),
            title: const MenuText('Tutorial'),
            onTap: () {
              Navigator.pop(context);
              ShowCaseWidget.of(context).startShowCase(globalKeys);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.close,
            ),
            title: const MenuText('Exit'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class MenuText extends StatelessWidget {
  final String text;

  const MenuText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}

// Page transition animation
Route slideIn(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, page) {
      const curve = Curves.decelerate;
      const beginSlide = 1.0;
      const endSlide = 10.0;
      var tweenSlide = Tween(begin: beginSlide, end: endSlide)
          .chain(CurveTween(curve: curve));
      const beginFade = 0.0;
      const endFade = 1.0;
      var tweenFade =
          Tween(begin: beginFade, end: endFade).chain(CurveTween(curve: curve));

      final slideTransition =
          SizeTransition(sizeFactor: animation.drive(tweenSlide), child: page);
      return FadeTransition(
          opacity: animation.drive(tweenFade), child: slideTransition);
    },
  );
}
