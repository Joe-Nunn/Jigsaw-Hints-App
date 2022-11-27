import 'package:flutter/material.dart';
import 'constants.dart';

class JigsawAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const JigsawAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(defaultAppBarPadding),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
      flexibleSpace: const Image(
        image: AssetImage('images/appbar_bg.png'),
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
