import 'dart:async';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:postea_frontend/colors.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/customWidgets/customNavBar.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
//import 'package:postea_frontend/customWidgets/customAppBar.dart';
import 'package:postea_frontend/data_models/timer.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:postea_frontend/customWidgets/topic_pill.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _scrollController = new ScrollController();
  var postTextController = new TextEditingController();
  var postTitleController = new TextEditingController();
  

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      var timer = Provider.of<TimerCount>(context, listen: false);
      timer.changeVal();
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home"),),
        BottomNavigationBarItem(icon: Icon(Icons.create), title: Text("New Post"),),
        BottomNavigationBarItem(icon: Icon(Icons.trending_up), title: Text("Trending"))
      ],
      onTap: (value) {
        // Making a post logic
        print("pressde");
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                width: screenWidth/1.1,
                height: screenHeight/1.8,
                              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                      padding: EdgeInsets.only(left: 18, right: 18, top: 15),
                        color: Colors.transparent,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title",
                          ),
                          controller: postTitleController,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        scrollDirection: Axis.vertical,                       
                        child: TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Post description"
                          ),
                          controller: postTextController,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 13, right: 13),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            IconButton(icon: Icon(Icons.camera_alt, color: Colors.grey,), onPressed: (){}),
                            IconButton(icon: Icon(Icons.attachment, color: Colors.grey,), onPressed: (){}),
                            IconButton(icon: Icon(Icons.location_on, color: Colors.grey,), onPressed: (){}),
                            Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 15),
                              alignment: Alignment.centerRight,
                              child: Container(
                                alignment: Alignment.center,
                                height: screenHeight/22,
                                width: screenWidth/4.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.grey)
                                ),
                                child: Text("Topic", style: TextStyle(fontSize: 15),),
                              ),
                            ),
                          )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 13),
                        alignment: Alignment.center,
                        child: Text("Post"),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.menu),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){},),
          IconButton(icon: Icon(Icons.notifications), onPressed: (){}),
          IconButton(icon: Icon(Icons.account_circle), onPressed: (){
            Navigator.of(context).pushNamed('/profile');
          }),
          
        ],
      ),
      backgroundColor: bgColor,
      body: Column(
        children: [
          Container(
            height: 50,
            width: screenWidth,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                TopicPill(textdata: "Memes", col1: Colors.purple[900], col2: Colors.purple[400]),
                TopicPill(textdata: "Chess", col1: Colors.green[700], col2: Colors.lightGreen[400]),
                TopicPill(textdata: "Games", col1: Colors.blue[700], col2: Colors.lightBlueAccent[200]),
                TopicPill(textdata: "News", col1: Colors.red[700], col2: Colors.pink[400]),
                TopicPill(textdata: "Rock", col1: Colors.deepPurple[700], col2: Colors.red[500]),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
              child: ListView(
                children: [
                  PostTile(),
                  PostTile(),
                  PostTile()

                
              ],
            ),
          )
         

        ],

        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text("This timer is changing"),
        //     Consumer<TimerCount>(builder: (context, data, child){
        //       return AutoSizeText(
        //         data.getTime().toString(),
        //         style: TextStyle(fontSize: 15),
        //         );
        //     })
        //   ],

        // )
      ),
    );
  }
}