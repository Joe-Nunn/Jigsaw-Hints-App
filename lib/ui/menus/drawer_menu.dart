import 'package:flutter/material.dart';
import 'package:jigsaw_hints/settings/settings_page.dart';
import 'package:jigsaw_hints/ui/animations/animations.dart';
import 'package:jigsaw_hints/ui/dialogs/info_dialogs.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../utils/constants.dart';
import '../../pages/gallery_screen.dart';

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
            title: const MenuText('Box Covers'),
            onTap: () {
              Navigator.push(context, slideIn(const GalleryScreen()));
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
            title: const MenuText('Tips'),
            onTap: () {
              Navigator.pop(context);
              ShowCaseWidget.of(context).startShowCase(globalKeys);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.video_camera_back_outlined,
            ),
            title: const MenuText('Tutorial'),
            onTap: () => showInfoDialog(
              context,
              title: "How to use the app?",
              content: "Are you sure?",
              titleBgColor: logoBgColour,
              titleFontColor: logoFontColour,
              includePicture: true,
              picture: Image.asset("images/thumbnail.png"),
            ),
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
