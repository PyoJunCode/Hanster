import 'package:flutter/material.dart';
import 'package:hanster_app/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Nanumsquare',
        primarySwatch: Colors.blue,
        primaryColor: const Color(0XFFB7C2F3),
        accentColor: Colors.white,
      ),
      home: loginPage(),
    );
  }
}

