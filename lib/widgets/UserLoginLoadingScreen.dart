import 'package:busplanner/domain/User.dart';
import 'package:flutter/material.dart';

class UserLoginLoadingScreen extends StatefulWidget {
  final Function setConnectedUser;
  final User connectedUser;

  UserLoginLoadingScreen(this.connectedUser, this.setConnectedUser);

  @override
  _UserLoginLoadingScreenState createState() =>
      new _UserLoginLoadingScreenState();
}

class _UserLoginLoadingScreenState extends State<UserLoginLoadingScreen> {
  late User connectedUser;

  _UserLoginLoadingScreenState();

  @override
  void initState() {
    super.initState();
    connectedUser = widget.connectedUser;

    this.connectedUser.loginAndReturnSessionId().then((result) {
      setState(() {
        this.connectedUser.userId = result;
        widget.setConnectedUser(this.connectedUser);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }
}
