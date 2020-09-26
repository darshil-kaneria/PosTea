import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
import 'package:postea_frontend/customWidgets/showUpAnimation.dart';
import 'package:postea_frontend/data_models/process_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './loggedIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _emailText = "What's your \nEmail ID?";
  var _usernameText = "Select a \nUsername";
  var _passwordText = "Enter your \nPassword";
  var _almostThere = "You're almost \ndone!";
  var _checkBoxVal = false;
  var _helperText;
  var _nextButtonText;

  var _email;
  var _username;
  var _password;

  var _emailTextController = new TextEditingController();
  var _usernameTextController = new TextEditingController();
  var _passwordTextController = new TextEditingController();

  var _scrollController = new ScrollController();
  var _pos;

  var alignStart = Alignment.topCenter;
  var aLignEnd = Alignment.bottomRight;

  bool _emailValidate = false;
  bool _usernameValidate = false;
  bool _passwordValidate = false;
  bool _validateAll = false;

  var _validateText = "";

  bool _revealPass = false;

  @override
  void initState() {
    _nextButtonText = "Next";
    _helperText = _emailText;
    _pos = 0;
    super.initState();
  }

  void changePassVisibility(var _revealPass) {
    setState(() {
      if (_revealPass) {
        _revealPass = false;
      } else
        _revealPass = true;
      print("PRESSED changed to $_revealPass");
    });
  }

  void changeHelperText(var screenWidth, var screenHeight) {
    print("POS is $_pos");
    setState(() {
      if (_pos == 0) {
        _helperText = _emailText;
        print("HEREHERE1");
      } else if (_pos == screenWidth) {
        _helperText = _usernameText;
        print("HEREHERE2");
      }
      else if(_pos == screenWidth *2){
          print("HEREHERE3");
         _helperText = _passwordText;
        
      }
      else if(_pos == screenWidth *3){
          _helperText = _almostThere;
        _nextButtonText = "Sign Up";

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
              bgGradStart,
              bgGradEnd,
            ],
                stops: [
              0.3,
              1
            ])),
        child: Center(
          child: Container(
              height: screenHeight / 2,
              width: screenWidth,
              //  color: Colors.black26, for debugging
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ShowUpAnimation(
                      delay: 200,
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        height: screenHeight / 8,
                        width: screenWidth,
                        child: AutoSizeText(_helperText,
                            style: TextStyle(
                                fontSize: 50,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        height: screenHeight / 4,
                        child: ListView(
                           // physics: NeverScrollableScrollPhysics(),
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(
                                width: screenWidth,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: TextField(
                                        controller: _emailTextController,
                                        decoration: InputDecoration(
                                          errorText: _emailValidate? _validateText: null,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red[400]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: loginButton),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            hintText: "Email ID",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50)))),
                                  ),
                                ),
                              ),
                              
                              SizedBox(
                                width: screenWidth,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: TextField(
                                        controller: _usernameTextController,
                                        decoration: InputDecoration(
                                          errorText: _usernameValidate?_validateText:null,
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            hintText: "Username",
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red[400]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: loginButton),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: TextField(
                                        controller: _passwordTextController,
                                        obscureText: !_revealPass,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  this._revealPass =
                                                      !(this._revealPass);
                                                });
                                              },
                                              icon: Icon(
                                                _revealPass
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.red[400],
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red[400]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: loginButton),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            hintText: "Password",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50)))),
                                  ),
                                ),
                              ),                              
                              SizedBox(
                                width: screenWidth,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: CheckboxListTile(
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: Colors.red[300],
                                      title: Text("I am 13 years of age or older"),
                                      value: _checkBoxVal, 
                                      onChanged: (newVal) {
                                        setState(() {
                                          _checkBoxVal = newVal;
                                        });
                                      }
                                      ),
                                  ),
                                ),
                              ),
                            ])),
                    ButtonTheme(
                      height: screenHeight / 16,
                      minWidth: screenWidth / 3,
                      child: RaisedButton(
                        elevation: 1,
                        color: loginButton,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.red[700])),
                        onPressed: () async {
                          
                          if (_pos == 0) {
                            _email = _emailTextController.text;

                          List retEmail =
                                ProcessSignUp(email: _email).validateEmail();
                          if(retEmail[0] == 0){
                            _emailValidate = true;
                          }
                          else{
                            print(retEmail[1]);
                            return;
                          }
                          
                          print(retEmail);
                          

                            // Handle any email errors below

                            _scrollController.animateTo(screenWidth,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);

                            _pos = screenWidth;
                            changeHelperText(screenWidth, screenHeight);
                          } else if (_pos == screenWidth) {
                            _username = _usernameTextController.text;

                            List retUsername =
                                await ProcessSignUp(username: _username)
                                    .validateUsername();

                            // Handle any username errors below

                            // duplicate username exists
                            if (retUsername[0] == 0) {
                              // Scaffold.of(context).showSnackBar(SnackBar(
                              //     content:
                              //         Text("This username already exists.")));
                               _usernameValidate = true;
                               print(retUsername);
                               
                              
                            }
                            else{

                             print(retUsername);
                              _usernameValidate = false;
                              return;
                            }

                            _scrollController.animateTo(screenWidth * 2,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);

                            _pos = screenWidth * 2;
                            changeHelperText(screenWidth, screenHeight);
                          } else if(_pos == screenWidth * 2){
                            // basic checking and store the password

                            _password = _passwordTextController.text;

                            List retPassword =
                                ProcessSignUp(password: _password)
                                    .validatePassword();

                            // Handle any password errors below

                            // Map<Object, Object> signUp = ProcessSignUp(
                            //         username: _username, password: _password)
                            //     .processSignupRequest();

                            if(retPassword[0] == 0){
                              _validateAll = true;
                            }
                            else{
                              _validateAll = false;
                              print("failed");
                              print(retPassword);
                            }

                            // return this.errObj;

                            print(
                                "email: $_email, Username: $_username, Password: $_password");
                            _scrollController.animateTo(screenWidth * 3,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);

                            _pos = screenWidth * 3;
                            changeHelperText(screenWidth, screenHeight);
                                
                          } else if (_pos == screenWidth * 3){

                            if(_checkBoxVal == true){
                              List retSignUp = await ProcessSignUp(email: _email, username: _username, password: _password).processSignupRequest();

                              if(retSignUp[0] == 0){

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoggedIn()));
                              }
                            }
                          }
                          
                        },
                        child: Container(
                            child: Text(
                          _nextButtonText,
                          style: TextStyle(
                              fontFamily: "Helvetica",
                              color: Colors.white,
                              fontSize: 18),
                        )),
                      ),
                    )
                  ])),
        ),
      ),
    );
  }
}
