import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jigsaw_hints/provider/camera_mode.dart';

class GuidelineBox extends StatelessWidget {
  const GuidelineBox({
    Key? key,
    required Map<String, double> position,
    required Map<String, double> size,
    required CameraMode mode,
  })  : _position = position,
        _size = size,
        _mode = mode,
        super(key: key);

  final Map<String, double> _position;
  final Map<String, double> _size;
  final CameraMode _mode;

  @override
  Widget build(BuildContext context) {
    return _mode == CameraMode.piece
        ? pieceOverlay(context)
        : boxOverlay(context);
  }

  Positioned pieceOverlay(BuildContext context) {
    return Positioned(
      left: _position['x'],
      top: _position['y'],
      child: Container(
        width: _size['w_piece'],
        height: _size['h_piece'],
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Theme.of(context).colorScheme.tertiary,
            child: Text(
              'Jigsaw Piece',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ).animate().fade(duration: 2.seconds),
    );
  }

  Positioned boxOverlay(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: _size['w_box'],
        height: _size['h_box'],
        decoration: BoxDecoration(
          border: Border.all(
            width: 5,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              'Box Cover',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ).animate().fade(duration: 2.seconds),
    );
  }
}
