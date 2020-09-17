import 'package:flutter/material.dart';
import '../colors.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: Container(
                child: TextFormField(
                  decoration: InputDecoration(
                  labelText: 'Enter your username'
                  ),
                )
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    bgColor,
                    profileButtoColor,
                  ])
              ),
            ),
          ],)
      ),
    );
  }
}