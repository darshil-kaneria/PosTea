import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';

class ProcessTimeline{

  List<Post> postList = [];
  var firstPostTime = null;
  var offset = 0;
  var temp;
  int profile_id;
  bool isEnd = false;
  bool postRetrieved = true;
  Map<String, dynamic> posts;

  ProcessTimeline(this.profile_id);

  Future<http.Response> getPosts() async {
  
    http.Response resp;
    if(isEnd != true){
      postRetrieved = false;
      print("POST RETRIEVED IS: "+ postRetrieved.toString());
       if(firstPostTime == null){
         print("IS NULL");
         var url = "http://postea-server.herokuapp.com/refreshTimeline?profile_id="+profile_id.toString()+"&post_offset="+offset.toString();
        resp = await http.get(url);
        
        postRetrieved = true;
     print("POST RETRIEVED IS: "+ postRetrieved.toString());

    posts = jsonDecode(resp.body);
    print(posts['error']);
    if(posts['result'].length == 0 || posts['error'] == 1){
      print("Reached end");
      isEnd=true;
    }
    print("OFFSET IS: "+offset.toString());
    if(isEnd == false){
      firstPostTime = posts['result'][0]['creation_date'].toString();
      var dateString = DateTime.parse(firstPostTime).toString();
      print(dateString.substring(0,dateString.length-5));
      firstPostTime = dateString.substring(0,dateString.length-5);
      
      await processPosts();

    } 
    }
    else{
      print("IS NOT NULL");
      var url = "http://postea-server.herokuapp.com/refreshTimeline?profile_id="+profile_id.toString()+"&post_offset="+offset.toString()+"&post_time='"+firstPostTime+"'";
        resp = await http.get(url);
        
        postRetrieved = true;
     print("POST RETRIEVED IS: "+ postRetrieved.toString());

    posts = jsonDecode(resp.body);
    print(posts['error']);
    if(posts['result'].length == 0 || posts['error'] == 1){
      print("Reached end");
      isEnd=true;
    }
    print("OFFSET IS: "+offset.toString());
    if(isEnd == false){
      processPosts();
    } 
    }
      
     
    

    }
    
    return resp;
  }

  processPosts() async {

    for(int i = 0; i < posts['result'].length; i++){

      http.Response resp = await http.get("http://postea-server.herokuapp.com/profile/"+posts['result'][i]['profile_id'].toString());
      Map<String, dynamic> profileJson = jsonDecode(resp.body);
      // print(profileJson['message']['name']);
      Post newPost = Post(
        posts['result'][i]['post_id'].toString(),
        posts['result'][i]['profile_id'].toString(),
        posts['result'][i]['post_description'].toString(),
        posts['result'][i]['topic_id'].toString(),
        posts['result'][i]['post_img'].toString(),
        posts['timeDiff'][i].toString(),
        posts['result'][i]['post_likes'].toString(),
        posts['result'][i]['post_dislikes'].toString(),
        posts['result'][i]['post_comments'].toString(),
        posts['result'][i]['post_title'].toString(),
        profileJson['message']['name']
        // "Darshil Kaneria"
      );
      print(posts['result'][i]['post_id']);
      postList.add(newPost);

    }
    print(postList.length);
    
  }

  setOffset(offset){

    this.offset = offset;

  }

  clearTimeline(){
    postList.clear();
    this.offset = 0;
    this.isEnd = false;
    firstPostTime = null;
    print("DONE");
  }

}