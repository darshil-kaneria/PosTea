import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   printAns();
// }

printAns() async {
  var url =
      "http://postea-server.herokuapp.com/refreshTimeline?profile_id=1&post_offset=0";
  http.Response resp = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: "Bearer posteaadmin",
    },
  );
  Map<String, dynamic> post = jsonDecode(resp.body);

  print(post['result'].length);
}
