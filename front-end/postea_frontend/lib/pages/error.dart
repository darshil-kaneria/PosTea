import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';

// Get error code using Provider - not implemented yet

class ErrorPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      body: Center(
              child: Container(
                height: screenHeight/1.2,
                width: screenWidth/1.2,
                alignment: Alignment.center,
                // color: Colors.black26,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("spilled_cup_image"),
                    Text("Uh oh! Something went wrong.")
                  ]
                ),
        ),
      ),
      
    );
  }
}