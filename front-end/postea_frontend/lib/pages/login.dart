import 'package:flutter/material.dart';
import '../colors.dart';

class Login extends StatelessWidget {

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void dispose(){

    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              bgGradStart,
              bgGradEnd,
            ],
                stops: [
              0.3,
              1
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(child: Text("PosTea Logo here")),
                  height: MediaQuery.of(context).size.height / 3,
                  margin: EdgeInsets.only(top: 30),
                  // color: Colors.amber,
                ),
                Container(
                    // color: Colors.black38,
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 30),
                                hintText: "Username",
                                hoverColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: loginButton),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red[400]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 30),
                                  hintText: "Password",
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: loginButton),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[400]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  )),
                            ))
                      ],
                    )),
                Container(
                    // color: Colors.blueAccent,
                    height: MediaQuery.of(context).size.height / 5.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonTheme(
                          height: MediaQuery.of(context).size.height / 16,
                          minWidth: MediaQuery.of(context).size.width / 3,
                          child: RaisedButton(
                            elevation: 1,
                            color: loginButton,
                            highlightColor: Colors.red[700],
                            onPressed: () {
                              // Login details retrieved here

                              var username = _usernameController.text;
                              var password = _passwordController.text;

                              print("Username is $username and password is $password");

                              // Send these to auth handling class
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Colors.white70
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.redAccent)),
                          ),
                        ),
                        Text(
                          "Forgot my password",
                          style: TextStyle(color: Colors.black26),
                        ),
                        Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.black26),
                        )
                      ],
                    ))
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ),
      ),
    );
  }
}
