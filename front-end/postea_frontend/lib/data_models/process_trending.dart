import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';

class ProcessTrending {
  int profileId;

  ProcessTrending({this.profileId});

  List<Post> postList = [];
  var firstPostTime = null;
  var offset = 0;
  var temp;
  bool isEnd = false;
  bool postRetrieved = true;
  String mid;
  List<dynamic> posts;

  http.Response resp;

  Future<http.Response> getPosts() async {
    var url = "http://postea-server.herokuapp.com/getTrendingPosts";
    await http.get(url).then((value) async {
      resp = value;
      posts = jsonDecode(value.body);
      await processPosts();
    });
    return resp;
  }

  processPosts() async {
    print("THIS IS SOMETHING HARDCODED");
    print(posts[0]);
    for (int i = 0; i < posts.length; i++) {
      // http.Response resp = await http.get(
      //     "http://postea-server.herokuapp.com/profile/" +
      //         posts[i]['profile_id'].toString());
      // Map<String, dynamic> profileJson = jsonDecode(resp.body);
      // print(profileJson['message']['name']);
      
      Post newPost = Post(
          posts[i]['post_id'].toString(),
          posts[i]['profile_id'].toString(),
          posts[i]['post_description'].toString(),
          posts[i]['topic_id'].toString(),
          posts[i]['post_img'].toString(),
          // posts['timeDiff'][i].toString(),
          "3 hours ago",
          posts[i]['post_likes'].toString(),
          posts[i]['post_dislikes'].toString(),
          posts[i]['post_comments'].toString(),
          posts[i]['post_title'].toString(),
          posts[i]['name'].toString()
          // "Darshil Kaneria"
          );
      print(posts[i]['post_id']);
      postList.add(newPost);
    }
    print(postList.length);
  }

  setOffset(offset) {
    this.offset = offset;
  }

  clearTimeline() {
    postList.clear();
    this.offset = 0;
    this.isEnd = false;
    firstPostTime = null;
    print("DONE");
  }
}
