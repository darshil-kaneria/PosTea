import 'dart:ui';

import 'package:flutter/material.dart';

class CustomNavBar {

  BuildContext context;
  CustomNavBar(this.context);
  
  static getNavBar(context){
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
                  height: screenHeight/13,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );

  }
}