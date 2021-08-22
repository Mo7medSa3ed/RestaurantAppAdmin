import 'package:flutter/foundation.dart';

class Specials extends ChangeNotifier {
// int amount=1;
//bool productselected = false;
//bool scroll = false;
  bool istextempty = true;

  changeIsEmpty(v) {
    istextempty = v;
    notifyListeners();
  }
}
