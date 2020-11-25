import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postea_frontend/main.dart';

class Comments extends StatefulWidget {
  var personName;
  var comment;
  var postID;
  var profileID;

  Comments(this.profileID, this.comment, this.personName);

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
                  child: FutureBuilder(
                    future: FirebaseStorageService.getImage(context, widget.profileID.toString()),
                    builder: (context, snapshot) {
                      return CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data),
                      backgroundColor: Colors.deepPurpleAccent[50],
                      radius: 15,
                    );
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: AutoSizeText(
                      this.personName,
                      style:
                          Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  AutoSizeText(
                    this.comment,
                    // "{\"post retrieved\": \"success\"}",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.thumb_up,
              color: Theme.of(context).buttonColor,
              size: 17,)
            ],
          ),
        ],
      ),
    );
  }
}
class FirebaseStorageService extends ChangeNotifier {
  FirebaseStorageService();
  static Future<dynamic> getImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(image)
        .getDownloadURL();
  }
}
