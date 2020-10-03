import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PostTile extends StatefulWidget {
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(top: 10, left: 12, right: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 40,
            ),
            title: Text(
              "Carl Grey",
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 15,
                  color: Colors.grey,
                ),
                Text("with Darshil Kaneria")
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: Colors.grey),)
            ),
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Text(
                    "This Spring, we will be launching TeraMart with all new features!",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                subtitle: AutoSizeText(
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                )),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.thumb_up), iconSize: 20, onPressed: (){},),
              IconButton(icon: Icon(Icons.thumb_down), iconSize: 20, onPressed: (){},),
              IconButton(icon: Icon(Icons.comment), iconSize: 20, onPressed: (){},),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: Text("3 hours ago", style: TextStyle(color: Colors.grey),),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
