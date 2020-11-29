import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'dart:convert';
//import 'package:postea_frontend/data_models/error_codes.json';

class ProcessSignUp {
  var email;
  var username;
  var password;
  int errCode = 0;
  var errMsg = "";
  Map<Object, Object> errObj;

  ProcessSignUp({this.email, this.username, this.password});

  Future<List> validateEmail() async {
    Pattern pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email)) {
      errCode = 100;
      errMsg = "Invalid Email";
      return [errCode, errMsg];
    } else {
      //check if duplicate email exists in firebase
      final databaseReference =
          FirebaseDatabase.instance.reference().child("users");

      await databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          value.forEach((key, value) {
            if (value == email) {
              errCode = 103;
              errMsg = "Email already exists!";
            }
          });
          // _email = values[username].toString();
          // final _finalemail =
          //     _email.substring(_email.indexOf(':') + 2, _email.length - 1);
          //print("final email is " + _finalemail + "\n_email is " + _email);
        });
      });
      print(errCode.toString() + " " + errMsg);
      return [errCode, errMsg];
    }
  }

  Future<List> validateUsername() async {
    Pattern pattern = r'^[a-z]+[0-9_]*[a-z0-9]*';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username)) {
      errCode = 101;
      errMsg = "Invalid Username";
      return [errCode, errMsg];
    } else {
      //check if duplicate username exists in firebase
      final databaseReference =
          FirebaseDatabase.instance.reference().child("users");

      await databaseReference.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (!values.containsKey(username)) {
            print("false");
            return false;
          } else {
            errCode = 104;
            errMsg = "Username already exists";
            return true;
          }
        });
      });
      return [errCode, errMsg];
    }
  }

  Object validatePassword() {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(password)) {
      errCode = 102;
      errMsg = "Invalid Password";
      return [errCode, errMsg];
    } else {
      // Return no error
      return [errCode, errMsg];
    }
  }

  // Call this method if none of the above methods return errors
  Future<List> processSignupRequest() async {
    // Sign Up user below

    try {
      // Creating New Account
      User user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      /* Finish Creating New Account */

      // checking if user creation is successful
      if (user != null) {
        // this.errObj = {0: "OK"};

        // Sending an email verification to the user.
        user.sendEmailVerification();

        // storing username and email to firebase realtime database
        final databaseReference = FirebaseDatabase.instance.reference();

        databaseReference
            .child('users')
            .child(username)
            .child(username)
            .set(email);

        var reqBody = JsonEncoder().convert({
          "newUser": username
        });
        Response response = await post(
          "http://postea-server.herokuapp.com/user",
          headers: {'Content-Type': 'application/json'},
          body: reqBody
          );

        if(response.statusCode == 200){
          print("FINISHED");
        }
        
        return [errCode, errMsg];
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoggedIn()));
        /* Finish storing username and email to firebase realtime database */
      } else {
        errCode = 105;
        errMsg = "Sign Up Failed";
        return [errCode, errMsg];
      }
    } catch (e) {
      print(e);
      errCode = 900;
      errMsg = "Unidentified error";
      return [errCode, errMsg];
    }
  }
}
