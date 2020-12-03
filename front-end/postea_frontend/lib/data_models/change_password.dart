import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword {
  var password;

  ChangePassword();

  setPassword(String newPassword) async {
    User user = FirebaseAuth.instance.currentUser;

    user.updatePassword(newPassword).then((value) {
      print("user password updated successfully");

      return "success";
    });

    return "fail";
  }
}
