import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';

class ProcessTimeline{

  List<Post> postList = [];
  var offset = 0;
  var temp;
  int profile_id;
  bool isEnd = false;
  Map<String, dynamic> posts;

  ProcessTimeline(this.profile_id);

  Future<http.Response> getPosts() async {
    http.Response resp;
    if(isEnd != true){

      var url = "http://postea-server.herokuapp.com/refreshTimeline?profile_id="+profile_id.toString()+"&post_offset="+offset.toString();
     resp = await http.get(url);
    posts = jsonDecode(resp.body);
    print(posts['result'][0]);
    if(posts['result'].length == 0 || posts['error'] == "1"){
      // print("Reached end");
      isEnd=true;
    }
    print("OFFSET IS: "+offset.toString());
    // if(isEnd == false)
    processPosts();
    

    }
    
    return resp;
  }

  processPosts() {

    for(int i = 0; i < posts['result'].length; i++){

      Post newPost = Post(
        posts['result'][i]['post_id'].toString(),
        posts['result'][i]['profile_id'].toString(),
        posts['result'][i]['post_description'].toString(),
        posts['result'][i]['topic_id'].toString(),
        posts['result'][i]['post_img'].toString(),
        posts['result'][i]['creation_date'].toString(),
        posts['result'][i]['post_likes'].toString(),
        posts['result'][i]['post_dislikes'].toString(),
        posts['result'][i]['post_comments'].toString(),
        posts['result'][i]['post_title'].toString()
      );
      print(posts['result'][i]['post_id']);
      postList.add(newPost);

    }
    print(postList.length);
    
  }

  setOffset(offset){

    this.offset = offset;

  }

}