// Use only if Default appbar cannot be customized.

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:postea_frontend/colors.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  // final String title;
  // final Widget child;
  // final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  CustomAppBar({
    // @required this.title,
    // @required this.child,
    // @required this.onPressed,
    this.onTitleTapped
  })
  : preferredSize = Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'title',
                transitionOnUserGestures: true,
                child: Card(
                  color: bgColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: InkWell(
                    onTap: onTitleTapped,
                    child: Container(
                      width: MediaQuery.of(context).size.width/2, // Have to subtract 8 px on Moto G5 plus
                      height: 50,
                      child: Align(alignment: Alignment.center,
                      child: Text("CustomAppBar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),),
                      )
                    )
                  ),
                ),
                Hero(
                tag: 'topBarBtn',
                child: Card(
                  color: bgColor,
                  elevation: 2,
                  shape: kBackButtonShape,
                  child: MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width/2 - 16,
                    elevation: 10,
                    shape: kBackButtonShape,
                    onPressed: () {
                      
                    },
                  ),
                ),
              ),
            ],)
        ]
      ),
    );
  }
}

ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(5)
);

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
  // color: Colors.black54,
);