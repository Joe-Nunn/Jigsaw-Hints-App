import 'package:flutter/material.dart';

class TorchProvider extends ChangeNotifier {
  bool _status = false;

  bool get status => _status;

  set status(bool torchStatus) {
    if (torchStatus != _status) {
      _status = torchStatus;
    }
  }
}
