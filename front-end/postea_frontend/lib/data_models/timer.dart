import 'package:flutter/cupertino.dart';

class TimerCount extends ChangeNotifier{
  int counter = 60;

  int getTime(){
    return counter;
  }

  void changeVal(){
    counter--;
    notifyListeners();
  }
}