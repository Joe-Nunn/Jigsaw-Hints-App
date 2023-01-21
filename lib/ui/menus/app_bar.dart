import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class JigsawAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const JigsawAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(defaultAppBarPadding),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
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
