import 'package:flutter/cupertino.dart';

class ProcessLogin{

  var username;
  var password;

  ProcessLogin({@required this.username, this.password});

  bool validateString(){

    // Validate the input string before authenticating.

    Pattern pattern = r'^[A-Za-z0-9]+(?:[@_\.-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(username)){
      return false;
    }
    else return true;
  }

  Object authenticate(){

    int errCode;
    var errMsg;

    Object errObj = {errCode: errMsg};

    // Add Authentication part here

    return errObj;

  }
  
}