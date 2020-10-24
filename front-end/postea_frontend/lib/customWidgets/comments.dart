import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                      "Vidit Shah",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(
                    "This is beautiful!",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 180),
                child: Icon(CupertinoIcons.heart_solid),
              )
            ],
          ),
        ],
      ),
    );
  }
}
