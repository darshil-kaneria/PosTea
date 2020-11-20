import 'dart:ui';

import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget{

  BuildContext context;
  final Function(int) onTap;
  CustomNavBar(this.context, {this.onTap}){
    
  } 
  
  Widget build(context){
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Positioned(
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10
              ),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  width: screenWidth,
                  height: screenHeight/14,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.home, color: Colors.blueGrey[800]),onPressed: (){
              onTap(0);
              }),
            IconButton(icon: Icon(Icons.create, color: Colors.blueGrey[800],), onPressed: (){
              onTap(1);
              }),
            IconButton(icon: Icon(Icons.trending_up, color: Colors.blueGrey[800],), onPressed: (){
              onTap(2);
              }),
            IconButton(icon: Icon(Icons.alternate_email, color: Colors.blueGrey[800],), onPressed: (){
              onTap(3);
              })
          ],
        )
      ],
    );

  }
}