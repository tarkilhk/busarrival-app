import 'package:busplanner/utils/BackendRootURL.dart' as backendRootUrl;
import 'package:busplanner/widgets/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    // backendRootUrl.loadConfig("PROD");
    backendRootUrl.loadConfig("DEV");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hong Kong Bus',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
