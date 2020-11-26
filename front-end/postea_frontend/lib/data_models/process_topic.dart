import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class ProcessTopic {
  var topic_name;
  var topic_description;
  var topic_image;
  var topic_creator_id;
  int topic_id;
  var profile_id;

  List<Post> postList = [];
  var firstPostTime = null;
  var offset = 0;
  var temp;
  bool isEnd = false;
  bool postRetrieved = true;
  Map<String, dynamic> posts;

  ProcessTopic(
      {this.topic_name,
      this.topic_description,
      this.topic_image,
      this.topic_creator_id,
      this.topic_id,
      this.profile_id});

  Future<http.Response> makeTopic() async {
    var url = "http://postea-server.herokuapp.com/addtopicinfo";
    var topicInfo = {
      "topicText": this.topic_name,
      "topicID": 1,
      "topicCreatorID": this.topic_creator_id,
      "topicDescription": this.topic_description
    };
    var postTopicInfo = JsonEncoder().convert(topicInfo);
    http.Response response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: postTopicInfo);

    print(response.body);

    return response;
  }

  getTopicInfo() async {
    var url = "http://postea-server.herokuapp.com/topic?topic_id=" +
        topic_id.toString();
    http.Response response = await http.get(url);

    var topicInfo = jsonDecode(response.body);

    var info = {
      "name": topicInfo[0]["topic_name"],
      "desc": topicInfo[0]["topic_description"],
      "topic_creator_id": topicInfo[0]["topic_creator_id"]
    };

    return info;
  }

  Future<http.Response> getPosts() async {
    http.Response resp;
    if (isEnd != true) {
      postRetrieved = false;
      print("POST RETRIEVED IS: " + postRetrieved.toString());
      if (firstPostTime == null) {
        print("IS NULL");
        var url =
            "http://postea-server.herokuapp.com/refreshTopicTimeline?topic_id=" +
                topic_id.toString() +
                "&post_offset=" +
                offset.toString();
        resp = await http.get(url);

        postRetrieved = true;
        print("POST RETRIEVED IS: " + postRetrieved.toString());

        posts = jsonDecode(resp.body);
        print(posts['error']);
        if (posts['result'].length == 0 || posts['error'] == 1) {
          print("Reached end");
          isEnd = true;
        }
        print("OFFSET IS: " + offset.toString());
        if (isEnd == false) {
          firstPostTime = posts['result'][0]['creation_date'].toString();
          var dateString = DateTime.parse(firstPostTime).toString();
          print(dateString.substring(0, dateString.length - 5));
          firstPostTime = dateString.substring(0, dateString.length - 5);

          await processPosts();
        }
      } else {
        print("IS NOT NULL");
        var url =
            "http://postea-server.herokuapp.com/refreshTopicTimeline?topic_id=" +
                topic_id.toString() +
                "&post_offset=" +
                offset.toString() +
                "&post_time='" +
                firstPostTime +
                "'";
        resp = await http.get(url);

        postRetrieved = true;
        print("POST RETRIEVED IS: " + postRetrieved.toString());

        posts = jsonDecode(resp.body);
        print(posts['error']);
        if (posts['result'].length == 0 || posts['error'] == 1) {
          print("Reached end");
          isEnd = true;
        }
        print("OFFSET IS: " + offset.toString());
        if (isEnd == false) {
          processPosts();
        }
      }
    }

    return resp;
  }

  processPosts() async {
    for (int i = 0; i < posts['result'].length; i++) {
      // http.Response resp = await http.get(
      //     "http://postea-server.herokuapp.com/profile/" +
      //         posts['result'][i]['profile_id'].toString());
      // Map<String, dynamic> profileJson = jsonDecode(resp.body);
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
          posts['result'][i]['name'].toString(),
          posts['result'][i]['is_sensitive'].toString()
          // "Darshil Kaneria"
          );
      print(posts['result'][i]['post_id']);
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
