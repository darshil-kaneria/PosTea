import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProcessSignUp {
  var email;
  var username;
  var password;
  int errCode;
  var errMsg;
  Map<Object, Object> errObj;

  ProcessSignUp({this.email, this.username, this.password});

  Object validateEmail() {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[@_\.-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username)) {
      return {errCode: errMsg};
    } else {
      //check if duplicate email exists in firebase
      return {errCode: errMsg};
    }
  }

  bool validateUsername() {
    Pattern pattern = r'^[a-z]+[0-9_]*[a-z0-9]*';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username)) {
      //check if duplicate username exists in firebase
      final databaseReference =
          FirebaseDatabase.instance.reference().child("users");

      databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (!values.containsKey(username)) {
            return false;
          } else {
            return true;
          }
        });
      });
    }
  }

  Object validatePassword() {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(password)) {
      return {errCode: errMsg};
    } else {
      // Return no error
      return {errCode: errMsg};
    }
  }

  // Call this method if none of the above methods return errors
  Object processSignupRequest() async {
    // Sign Up user below

    try {
      // Creating New Account
      User user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      /* Finish Creating New Account */

      // checking if user creation is successful
      if (user != null) {
        this.errObj = {0: "OK"};

        // Sending an email verification to the user.
        user.sendEmailVerification();

        // storing username and email to firebase realtime database
        final databaseReference = FirebaseDatabase.instance.reference();

        databaseReference
            .child('users')
            .child(username)
            .child(username)
            .set(email);
        /* Finish storing username and email to firebase realtime database */
      } else {
        this.errObj = {1: "Sign Up Unsuccessful"};
      }
    } catch (e) {
      print(e);
      this.errObj = {e.hashCode: e};
    }

    return this.errObj;
  }
}
