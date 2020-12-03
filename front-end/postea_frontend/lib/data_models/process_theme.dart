import 'package:flutter/cupertino.dart';

class ProcessTheme extends ChangeNotifier {
  int theme = 1; // 1 for light, 0 for dark
  double fontSize = 1; // options are 1.3, 1, and 0.7
  void changeTheme() {
    if (theme == 1) {
      theme = 0;
    } else
      theme = 1;
    print("Hello");
    notifyListeners();
  }

  int get themeData => theme;

  void font_size(double number) {
    fontSize = number;
    notifyListeners();
  } 
}
