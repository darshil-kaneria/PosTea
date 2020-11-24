import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessTheme extends ChangeNotifier{
  int theme = 1; // 1 for light, 0 for dark
  
  void changeTheme(){
    if(theme == 1){
      theme = 0;
    }
    else theme = 1;
    print("Hello");
    notifyListeners();
  }

  int get themeData => theme;

  
}