import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _emailText = "What's your \nEmail ID?";
  var _usernameText = "Select a \nUsername";
  var _passwordText = "Enter your \nPassword";
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
  @override
  void initState() {
    _nextButtonText = "Next";
    _helperText = _emailText;
    _pos = 0;
    super.initState();
  }

  void changeHelperText(var screenWidth) {
    setState(() {
      if (_pos == 0)
        _helperText = _usernameText;
      else if (_pos == screenWidth) {
        _helperText = _passwordText;
        _nextButtonText = "Sign Up";
      }

      // else if(_pos == screenWidth*2)
      //   _helperText = _passwordText;
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
      body: Container(
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
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      height: screenHeight / 8,
                      width: screenWidth,
                      child: AutoSizeText(_helperText,
                          style: TextStyle(
                              fontSize: 50,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        height: screenHeight / 4,
                        child: ListView(
                            physics: NeverScrollableScrollPhysics(),
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
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            hintText: "Username",
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
                                        controller: _passwordTextController,
                                        obscureText: true,
                                        decoration: InputDecoration(
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
                        onPressed: () {
                          changeHelperText(_pos);

                          if (_pos == 0) {
                            // basic checking and store the email

                            _email = _emailTextController.text;
                            _emailTextController.text = "";

                            _scrollController.animateTo(screenWidth,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);

                            _pos = screenWidth;
                          } else if (_pos == screenWidth) {
                            // basic checking and store the username

                            _username = _usernameTextController.text;
                            _usernameTextController.text = "";

                            _scrollController.animateTo(screenWidth * 2,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);

                            _pos = screenWidth * 2;
                          } else {
                            // basic checking and store the password

                            _password = _passwordTextController.text;
                            _passwordTextController.text = "";

                            print(
                                "email: $_email, Username: $_username, Password: $_password");
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
