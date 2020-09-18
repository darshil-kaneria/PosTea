import 'package:flutter/material.dart';

import './loggedIn.dart';
import './authenticate.dart';
import 'loggedIn.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either logged in or authenticate widget.
    return LoggedIn();
  }
}
