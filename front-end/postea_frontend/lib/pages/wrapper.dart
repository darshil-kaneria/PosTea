import 'package:flutter/material.dart';

import './loggedIn.dart';
import './authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return either logged in or authenticate widget.
    return Authenticate();
  }
}
