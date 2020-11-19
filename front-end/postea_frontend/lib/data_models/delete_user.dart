import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteUser {
  User user;
  String email;
  String password;

  DeleteUser({this.user, this.email, this.password});

  deleteUserData() async {
    try {
      AuthCredential authCredential =
          EmailAuthProvider.credential(email: email, password: password);

      UserCredential userCredential =
          await user.reauthenticateWithCredential(authCredential);

      _deleteUserFromDatabase(email);

      await userCredential.user.delete();

      print("user deleted from authentication successfully!");
    } catch (e) {
      print("e is " + e.toString());
      return "fail";
    }

    return "success";
  }

  _deleteUserFromDatabase(String email) async {
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child("users");

      String username = await getUsername(email);

      databaseReference.child(username).remove();
    } catch (e) {
      print("e is " + e.toString());
    }
  }

  getUsername(String email) async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("users");

    var username = "No username found";

    await databaseReference.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> map = dataSnapshot.value;
      map.forEach((key, value) {
        var usernameEmail = value[key.toString()];
        if (usernameEmail == email) {
          username = key.toString();
        }
      });
    });
    return username;
  }
}
