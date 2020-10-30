import 'dart:convert';
import 'package:http/http.dart' as http;

class ProcessTopic {
  var topic_name;
  var topic_description;
  var topic_image;
  var topic_creator_id;
  var topic_id;
  var profile_id;

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
    var url = "http://postea-server.herokuapp.com/gettopic?topic_id=" +
        topic_id.toString();
    http.Response response = await http.get(url);

    var topicInfo = jsonDecode(response.body);

    var info = {
      "name": topicInfo[0]["topic_name"],
      "desc": topicInfo[0]["topic_description"]
    };

    return info;
  }
}
