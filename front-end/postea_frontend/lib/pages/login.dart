import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/data_models/process_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../colors.dart';
import 'loggedIn.dart';

class Login extends StatefulWidget {
  final bool loginSuccess = false;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  void checkUserLoggedIn() {
    User user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoggedIn()));
    }
  }

  logInUser(String email, String password) async {
    print(email);
    print(password);
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      print("hello from logInUser()");

      if (user != null) {
        print("hello from logInUser() success");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoggedIn()));
        // this.loginSucces = true;
      } else {
        print("hello from logInUser() err");
        // this.loginSucces = false;
      }
    } catch (e) {
      print(e);
      // username = "";
      password = "";
      // this.loginSucces = false;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        builder: (BuildContext context, double _value, Widget child) {
          return Opacity(
            opacity: _value,
            child: child,
          );
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          extendBodyBehindAppBar: true,
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
                                hintText: "Username or Email",
                                hoverColor: Colors.black,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: loginButton),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red[400]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
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
                                        BorderRadius.all(Radius.circular(100)),
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
                            onPressed: () async {
                              // Login details retrieved here

                              var username =
                                  _usernameController.text.trimRight();
                              var password = _passwordController.text;

                              print(
                                  "Username is $username and password is $password");

                              bool isValid = ProcessLogin(
                                      username: username, password: password)
                                  .validateString();

                              //Send these to auth handling class

                              var _email = username;
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(_email);

                              if (!emailValid) {
                                final databaseReference = FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child("users");

                                print("hello");

                                databaseReference
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  Map<dynamic, dynamic> values = snapshot.value;
                                  print(values[username][username].toString());
                                  _email =
                                      values[username][username].toString();
                                  logInUser(_email, password);
                                });
                              } else {
                                logInUser(_email, password);
                              }

                              // var ret = ProcessLogin(
                              //     username: username, password: password);

                              // bool logIn = ret.authenticate();

                              // print("logIn is " + logIn.toString());

                              // Extract error message if any.
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontFamily: "Helvetica",
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(color: Colors.redAccent)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Implement forgot password
                          },
                          child: Text(
                            "Forgot my password",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Implement signup
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.black54),
                          ),
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
