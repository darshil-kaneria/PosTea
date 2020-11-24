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
   
    print(postList.length);

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
      await processPosts();
   
    print("Post list length is: "+postList.length.toString());
    } 
    }
      
     
    

    }
    print("Reached return");
    return resp;
  }

  processPosts() async {

    for(int i = 0; i < posts['result'].length; i++){
      var name;
      if(posts['result'][i]['is_anonymous'].toString() == "1"){
        name = "Anonymous";
      }
      else{

        // http.Response resp = await http.get("http://postea-server.herokuapp.com/profile/"+posts['result'][i]['profile_id'].toString());
        // Map<String, dynamic> profileJson = jsonDecode(resp.body);
        // name = profileJson['message']['name'];
        name = posts['result'][i]['name'].toString();

      }
      
      // print(profileJson['message']['name']);
      Post newPost = Post(
        posts['result'][i]['post_id'].toString(),
        posts['result'][i]['profile_id'].toString(),
        posts['result'][i]['post_description'].toString(),
        posts['result'][i]['topic_id'].toString(),
        // posts['result'][i]['post_img'].toString(),
        "noimg",
        posts['timeDiff'][i].toString(),
        posts['result'][i]['post_likes'].toString(),
        posts['result'][i]['post_dislikes'].toString(),
        posts['result'][i]['post_comments'].toString(),
        posts['result'][i]['post_title'].toString(),
        name
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