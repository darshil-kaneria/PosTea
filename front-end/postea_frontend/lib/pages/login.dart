import 'package:flutter/material.dart';
import '../colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
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
                                hintText: "Username",
                                hoverColor: Colors.black,
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
                            onPressed: () {
                              // Login details retrieved here

                              var username = _usernameController.text;
                              var password = _passwordController.text;

                              print(
                                  "Username is $username and password is $password");
                              _usernameController.clear();
                              _passwordController.clear();

                              // Send these to auth handling class
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
