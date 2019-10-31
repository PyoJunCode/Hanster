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

        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFFffdbf8),
        accentColor: Colors.white,
      ),
      home: loginPage(),
    );
  }
}

