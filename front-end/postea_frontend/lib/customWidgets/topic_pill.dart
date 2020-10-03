import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TopicPill extends StatelessWidget {

  var textdata;
  Color col1;
  Color col2;

  TopicPill({@required this.textdata, this.col1, this.col2});

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(

      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      height: screenWidth/10,
      width: screenHeight/6,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          col1,
          col2
        ]),
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      child: Center(
        child: AutoSizeText(
          textdata,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      
    );
  }
}