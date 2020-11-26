import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:postea_frontend/customWidgets/postTile.dart';
import 'package:postea_frontend/data_models/process_trending.dart';

import '../colors.dart';

class Trending extends StatefulWidget {
  int profileId;

  Trending({this.profileId});
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  ProcessTrending trending;
  // Map<String, dynamic> topicInfo;

  Future<Response> getTopicContent() async {
    return trending.getPosts();
  }

  @override
  void initState() {
    // TODO: implement initState
    trending = ProcessTrending(profileId: widget.profileId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Trending", style: Theme.of(context).textTheme.headline4,),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).buttonColor),
      ),
      extendBodyBehindAppBar: false,
      body: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     margin: EdgeInsets.only(top: 15, left: 15),
            //     child: Text("Discover...",
            //         style:
            //             TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            //   ),
            // ),
            Expanded(
              flex: 10,
              child: Container(
                child: FutureBuilder(
                  future: getTopicContent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: trending.postList.length,
                        itemBuilder: (context, index) {
                          return PostTile(
                              trending.postList.elementAt(index).post_id,
                              trending.postList.elementAt(index).profile_id,
                              trending.postList
                                  .elementAt(index)
                                  .post_description,
                              trending.postList.elementAt(index).topic_id,
                              trending.postList.elementAt(index).post_img,
                              trending.postList.elementAt(index).creation_date,
                              trending.postList.elementAt(index).post_likes,
                              trending.postList.elementAt(index).post_dislikes,
                              trending.postList.elementAt(index).post_comments,
                              trending.postList.elementAt(index).post_title,
                              trending.postList.elementAt(index).post_name,
                              widget.profileId.toString(),
                              0,
                              trending.postList.elementAt(index).is_sensitive);
                        },
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(bgGradEnd),
                      ));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
