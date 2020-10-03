import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProcessLogin {
  var username;
  var password;
  var errObj;
  bool loginSucces = false;

  ProcessLogin({@required this.username, this.password});

  bool validateString() {
    // Validate the input string before authenticating.

    Pattern pattern = r'^[A-Za-z0-9]+(?:[@_\.-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username)) {
      return false;
    } else
      return true;
  }

  void logInUser(String email, String password) async {
    print(email);
    print(password);
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      print("hello from logInUser()");

      if (user != null) {
        this.errObj = {0: "OK"};
        print("hello from logInUser() success");
        this.loginSucces = true;
      } else {
        print("hello from logInUser() err");
        this.errObj = {1: "Login Unsuccessful"};
        this.loginSucces = false;
      }
    } catch (e) {
      print(e);
      this.errObj = {e.hashCode: e};
      username = "";
      password = "";
      this.loginSucces = false;
    }
  }

  bool authenticate() {
    int errCode;
    var errMsg;

    Map<Object, Object> errObj = {errCode: errMsg};

    // Add Authentication part here
    var _email = username;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);

    if (!emailValid) {
      final databaseReference =
          FirebaseDatabase.instance.reference().child("users");

      print("hello");

      databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          _email = values[username].toString();
          final _finalemail =
              _email.substring(_email.indexOf(':') + 2, _email.length - 1);
          print("final email is " + _finalemail + "\n_email is " + _email);
          logInUser(_finalemail, password);
        });
      });
    } else {
      logInUser(_email, password);
    }

    return this.loginSucces;
  }
}
