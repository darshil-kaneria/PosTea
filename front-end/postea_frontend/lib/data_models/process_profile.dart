import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';

class ProcessProfile {
  static void getProfileName() async {
    Response response = await get(
      "http://postea-server.herokuapp.com/?number=1000",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer posteaadmin",
      },
    );
    var serverResponse = response.body;
    print(serverResponse);
    return;
  }
}
