import 'package:flutter/material.dart';

class GuidelineBox extends StatelessWidget {
  const GuidelineBox({
    Key? key,
    required Map<String, double> position,
  })  : _position = position,
        super(key: key);

  final Map<String, double> _position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position['x'],
      top: _position['y'],
      child: Container(
        width: _position['w'],
        height: _position['h'],
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              'Jigsaw Piece',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
