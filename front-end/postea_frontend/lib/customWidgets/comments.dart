import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  var personName;
  var comment;
  var postID;

  Comments(this.comment, this.personName);

  @override
  _CommentsState createState() => _CommentsState(this.comment, this.personName);
}

class _CommentsState extends State<Comments> {
  var comment;
  var personName;
  var screenWidth;

  _CommentsState(this.comment, this.personName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://picsum.photos/250?image=7"),
                    backgroundColor: Colors.deepPurpleAccent[50],
                    radius: 15,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      this.personName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(
                    this.comment,
                    // "{\"post retrieved\": \"success\"}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
