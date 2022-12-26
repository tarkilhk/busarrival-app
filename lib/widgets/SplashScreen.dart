import 'package:busplanner/domain/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Function setConnectedUser;

  SplashScreen(this.setConnectedUser);

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    this.loadLastConnectedUserFromPreferences();

//    this.loadUserList();
//    this.loadUserList().then(widget.setSessionId("toto"));
//    new Future.delayed(const Duration(seconds: 4));
//    Timer(Duration(seconds: 5),() => MyNavigator.goToUsers(context, [User("pi"), User("pi2")]));
  }

  @override
  Widget build(BuildContext context) {
    //build
    return Center(
      child: new Text("Welcome to Hong Kong Bus"),
    );
  }

  void loadLastConnectedUserFromPreferences() async {
    User user = User("0", "", []);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String readUserId = prefs.get('userId').toString();

    // TODO : Test that the below is working

    if (readUserId == "null") {
      widget.setConnectedUser(user);
    } else {
      User.loadUserFromBackendFromUserId(readUserId)
          .then((value) => widget.setConnectedUser(value));
    }
    print("Loaded last connected user : ${user.userName}");
  }
}
