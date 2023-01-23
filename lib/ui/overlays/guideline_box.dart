import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';

class GuidelineBox extends StatelessWidget {
  const GuidelineBox({
    Key? key,
    required Map<String, double> position,
    required CameraMode mode,
  })  : _position = position,
        _mode = mode,
        super(key: key);

  final Map<String, double> _position;
  final CameraMode _mode;

  @override
  Widget build(BuildContext context) {
    Color boxColor = _mode == CameraMode.piece
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.secondary;
    return Positioned(
      left: _position['x'],
      top: _position['y'],
      child: Container(
        width: _position['w'],
        height: _position['h'],
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: boxColor,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: boxColor,
            child: Text(
              _mode == CameraMode.piece ? 'Jigsaw Piece' : 'Box Cover',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ).animate().fade(duration: 2.seconds),
    );
  }
}
